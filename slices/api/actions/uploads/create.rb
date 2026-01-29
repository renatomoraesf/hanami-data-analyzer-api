# slices/api/actions/uploads/create.rb
require "dry/auto_inject"

module API
  module Actions
    module Uploads
      class Create < Api::Action
        include Dry::AutoInject(Hanami.app)[
          "repositories.sales_repo",
          "repositories.file_processing_repo", 
          "logger"
        ]

        def handle(request, response)
          logger.info("Upload endpoint accessed")
          
          file = request.params[:file]
          
          if file.nil? || !file.respond_to?(:[])
            return error_response(response, "Nenhum arquivo enviado.", 400)
          end

          tempfile = file[:tempfile]
          filename = file[:filename]
          
          temp_dir = Hanami.app.root.join("tmp", "uploads")
          FileUtils.mkdir_p(temp_dir)
          temp_path = File.join(temp_dir, "#{Time.now.to_i}_#{filename}")
          FileUtils.cp(tempfile.path, temp_path)

          processing = file_processing_repo.create(filename: filename, status: 'processing')
          
          processor = DataAnalyzerApi::Services::FileProcessor.new(
            file_path: temp_path,
            filename: filename
          )
          
          result = processor.call
          File.delete(temp_path) if File.exist?(temp_path)

          if result[:processed]
            sales_repo.create_many(result[:data]) if result[:valid_rows].to_i > 0
            file_processing_repo.update(processing.id, status: 'completed', valid_rows: result[:valid_rows])
            
            json_response(response, { 
              status: "success", 
              data: { processing_id: processing.id, rows: result[:valid_rows] } 
            }, status: 201)
          else
            file_processing_repo.update(processing.id, status: 'failed', errors: result[:errors].to_json)
            error_response(response, "Falha no processamento: #{result[:errors].join(', ')}", 422)
          end
        rescue => e
          logger.error("Erro no Upload: #{e.message}")
          error_response(response, "Erro interno: #{e.message}", 500)
        end

        private

        def json_response(response, data, status: 200)
          response.status = status
          response.body = data.to_json
          response.format = :json
        end

        def error_response(response, msg, status = 400)
          json_response(response, { error: msg }, status: status)
        end
      end
    end
  end
end
