# slices/api/actions/uploads/create.rb (com logging)
require "json"
require_relative "../../../../lib/data_analyzer_api/services/file_processor"

module Api
  module Actions
    module Uploads
      class Create < Api::Action
        include Deps[
          "persistence.repositories.sales_repo",
          "persistence.repositories.file_processing_repo",
          "logger",
          "file_logger"
        ]
        
        def handle(request, response)
          logger.info("Upload endpoint accessed")
          
          # Verificar se há arquivo no request
          file_param = request.params[:file]
          
          if file_param.nil? || !file_param.respond_to?(:[])
            logger.warn("No file provided in upload request")
            return error_response("Nenhum arquivo enviado. Envie um arquivo CSV/XLSX usando o campo 'file' (form-data)", 400)
          end
          
          # Salvar arquivo temporariamente
          tempfile = file_param[:tempfile]
          filename = file_param[:filename]
          
          if tempfile.nil?
            logger.error("Invalid file uploaded: tempfile is nil")
            return error_response("O arquivo enviado é inválido ou está corrompido", 400)
          end
          
          logger.info("File upload started: #{filename}, size: #{tempfile.size} bytes")
          
          # Registrar processamento
          processing = file_processing_repo.create_processing(filename, status: 'processing')
          file_logger.info("Processing started: ID #{processing.id}, filename: #{filename}")
          
          # Criar diretório temporário
          temp_dir = File.join(Dir.pwd, "tmp", "uploads")
          FileUtils.mkdir_p(temp_dir)
          
          # Salvar arquivo
          temp_path = File.join(temp_dir, "#{Time.now.to_i}_#{filename}")
          File.open(temp_path, "wb") { |f| f.write(tempfile.read) }
          
          # Processar arquivo
          processor = DataAnalyzerApi::Services::FileProcessor.new(
            file_path: temp_path,
            filename: filename
          )
          
          result = processor.call
          
          # Limpar arquivo temporário
          File.delete(temp_path) if File.exist?(temp_path)
          
          # Atualizar status do processamento
          if result[:processed]
            logger.info("File processed successfully: #{filename}, rows: #{result[:rows]}, valid: #{result[:valid_rows]}")
            file_logger.info("Processing completed: ID #{processing.id}, valid rows: #{result[:valid_rows]}")
            
            # Salvar no banco se houver dados válidos
            if result[:valid_rows] > 0 && sales_repo
              begin
                saved = sales_repo.create_many(result[:data])
                logger.info("Data saved to database: #{saved.count} records")
              rescue => e
                logger.error("Database save failed: #{e.message}")
                result[:errors] << "Erro ao salvar no banco: #{e.message}"
              end
            end
            
            file_processing_repo.update_processing(
              processing.id,
              status: 'completed',
              rows_processed: result[:rows],
              valid_rows: result[:valid_rows],
              saved_rows: result[:saved_rows] || 0,
              errors: result[:errors].empty? ? nil : result[:errors].to_json,
              processed_at: Time.now
            )
            
            json_response({
              status: "success",
              message: "Arquivo processado com sucesso",
              data: {
                processing_id: processing.id,
                filename: filename,
                rows_processed: result[:rows],
                valid_rows: result[:valid_rows],
                saved_rows: result[:saved_rows] || 0,
                sample_data: result[:data].first(3),
                errors: result[:errors].empty? ? nil : result[:errors]
              },
              metadata: {
                processed_at: Time.now.iso8601
              }
            }, status: 201)
            
          else
            logger.error("File processing failed: #{filename}, errors: #{result[:errors]}")
            file_logger.error("Processing failed: ID #{processing.id}, errors: #{result[:errors]}")
            
            file_processing_repo.update_processing(
              processing.id,
              status: 'failed',
              rows_processed: result[:rows],
              errors: result[:errors].to_json
            )
            
            error_response("Falha ao processar arquivo: #{result[:errors].join(', ')}", 422)
          end
          
        rescue => e
          logger.error("Upload processing error: #{e.class}: #{e.message}")
          logger.error(e.backtrace.first(5).join("\n"))
          file_logger.error("Critical error in upload: #{e.message}")
          
          # Em caso de erro, atualizar status
          if defined?(processing) && processing
            file_processing_repo.update_processing(
              processing.id,
              status: 'error',
              errors: { error: e.message, backtrace: e.backtrace.first(3) }.to_json
            )
          end
          
          error_response("Erro interno no processamento: #{e.message}", 500)
        end
        
        private
        
        def json_response(data, status: 200)
          self.status = status
          self.body = data.to_json
          headers["Content-Type"] = "application/json"
        end
        
        def error_response(message, status = 400)
          json_response({ error: message }, status: status)
        end
      end
    end
  end
end
