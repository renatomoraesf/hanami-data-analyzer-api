# lib/data_analyzer_api/services/csv_processor.rb
require "csv"
require "date"

module DataAnalyzerApi
  module Services
    class CsvProcessor
      class ProcessingError < StandardError; end
      
      def initialize(file_path:, filename:, repo: nil)
        @file_path = file_path
        @filename = filename
        @sales_repo = repo
        @results = {
          processed: false,
          rows: 0,
          valid_rows: 0,
          errors: [],
          saved_rows: 0,
          data: []
        }
      end
      
      def call
        validate_file
        data = parse_file
        save_to_database(data) if @sales_repo
        @results
      rescue => e
        @results[:errors] << e.message
        @results
      end
      
      private
      
      def validate_file
        raise ProcessingError, "Arquivo não encontrado" unless File.exist?(@file_path)
        
        file_size = File.size(@file_path)
        raise ProcessingError, "Arquivo muito grande (max 100MB)" if file_size > 100 * 1024 * 1024
        
        unless @filename.downcase.end_with?('.csv')
          raise ProcessingError, "Apenas arquivos CSV são suportados no momento"
        end
      end
      
      def parse_file
        parsed_data = []
        row_count = 0
        
        CSV.foreach(@file_path, headers: true, encoding: 'UTF-8') do |row|
          row_count += 1
          

          if row.to_h.values.compact.empty?
            @results[:errors] << "Linha #{row_count} vazia"
            next
          end
          

          sale_data = convert_row(row)
          
          if valid_sale?(sale_data)
            parsed_data << sale_data
            @results[:valid_rows] += 1
          else
            @results[:errors] << "Linha #{row_count} inválida"
          end
          
          @results[:rows] = row_count
          

          break if row_count >= 1000
        end
        
        @results[:data] = parsed_data.first(10)
        parsed_data
      end
      
      def convert_row(row)
        {
          transaction_id: row['id_transacao']&.strip,
          sale_date: parse_date(row['data_venda']),
          final_value: parse_decimal(row['valor_final']),
          subtotal: parse_decimal(row['subtotal']),
          discount_percent: row['desconto_percent']&.to_i || 0,
          sales_channel: row['canal_venda']&.strip,
          payment_method: row['forma_pagamento']&.strip,
          customer_id: row['cliente_id']&.strip,
          customer_name: row['nome_cliente']&.strip,
          customer_age: row['idade_cliente']&.to_i,
          customer_gender: row['genero_cliente']&.strip,
          customer_city: row['cidade_cliente']&.strip,
          customer_state: row['estado_cliente']&.strip,
          customer_income: parse_decimal(row['renda_estimada']),
          product_id: row['produto_id']&.strip,
          product_name: row['nome_produto']&.strip,
          product_category: row['categoria']&.strip,
          product_brand: row['marca']&.strip,
          unit_price: parse_decimal(row['preco_unitario']),
          quantity: row['quantidade']&.to_i || 1,
          profit_margin: row['margem_lucro']&.to_i || 0,
          region: row['regiao']&.strip,
          delivery_status: row['status_entrega']&.strip,
          delivery_days: row['tempo_entrega_dias']&.to_i || 0,
          seller_id: row['vendedor_id']&.strip
        }
      end
      
      def valid_sale?(sale_data)

        return false if sale_data[:transaction_id].to_s.empty?
        return false if sale_data[:sale_date].nil?
        return false if sale_data[:final_value].to_f <= 0
        return false if sale_data[:customer_id].to_s.empty?
        return false if sale_data[:product_id].to_s.empty?
        true
      end
      
      def parse_date(date_str)
        return nil if date_str.to_s.empty?
        Date.parse(date_str) rescue nil
      end
      
      def parse_decimal(value)
        return 0.0 if value.to_s.empty?
        value.to_s.gsub(',', '.').to_f
      end
      
      def save_to_database(data)
        return if data.empty?
        
        begin
          saved = @sales_repo.create_many(data)
          @results[:saved_rows] = saved.count
          @results[:processed] = true
        rescue => e
          @results[:errors] << "Erro ao salvar no banco: #{e.message}"
        end
      end
    end
  end
end
