# lib/data_analyzer_api/services/file_processor.rb
require "csv"
require "date"
require "roo"

module DataAnalyzerApi
  module Services
    class FileProcessor
      class ProcessingError < StandardError; end
      
      def initialize(file_path:, filename:)
        @file_path = file_path
        @filename = filename
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
        @results[:data] = data.first(10)
        @results[:valid_rows] = data.size
        @results[:processed] = true
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
        
        valid_extensions = ['.csv', '.xlsx', '.xls']
        extension = File.extname(@filename).downcase
        raise ProcessingError, "Apenas arquivos CSV, XLSX ou XLS são suportados" unless valid_extensions.include?(extension)
      end
      
      def parse_file
        extension = File.extname(@filename).downcase
        
        case extension
        when '.csv'
          parse_csv
        when '.xlsx', '.xls'
          parse_excel
        else
          raise ProcessingError, "Formato não suportado: #{extension}"
        end
      end
      
      def parse_csv
        parsed_data = []
        row_count = 0
        
        CSV.foreach(@file_path, headers: true, encoding: 'UTF-8') do |row|
          row_count += 1
          @results[:rows] = row_count
          

          next if row.to_h.values.compact.empty?
          

          sale_data = convert_row(row.to_h)
          
          if valid_sale?(sale_data)
            parsed_data << sale_data
          else
            @results[:errors] << "Linha #{row_count} inválida"
          end
          
          break if row_count >= 10000
        end
        
        parsed_data
      end
      
      def parse_excel
        parsed_data = []
        
        spreadsheet = Roo::Spreadsheet.open(@file_path)
        sheet = spreadsheet.sheet(0)
        

        headers = sheet.row(1).map { |h| h.to_s.strip.downcase.gsub(' ', '_') }
        

        required_headers = ['id_transacao', 'data_venda', 'valor_final', 'cliente_id', 'produto_id']
        missing_headers = required_headers - headers
        
        unless missing_headers.empty?
          raise ProcessingError, "Cabeçalhos obrigatórios faltando: #{missing_headers.join(', ')}"
        end
        

        (2..sheet.last_row).each do |row_num|
          @results[:rows] += 1
          row_data = {}
          
          headers.each_with_index do |header, index|
            value = sheet.cell(row_num, index + 1)
            row_data[header] = value
          end
          

          next if row_data.values.compact.empty?
          

          sale_data = convert_row(row_data)
          
          if valid_sale?(sale_data)
            parsed_data << sale_data
          else
            @results[:errors] << "Linha #{row_num} inválida"
          end
          
          break if row_num >= 10002
        end
        
        parsed_data
      end
      
      def convert_row(row_hash)

        standardized_row = {}
        row_hash.each do |key, value|
          standardized_key = key.to_s.strip.downcase.gsub(' ', '_')
          standardized_row[standardized_key] = value
        end
        
        {
          transaction_id: standardized_row['id_transacao']&.to_s&.strip,
          sale_date: parse_date(standardized_row['data_venda']),
          final_value: parse_decimal(standardized_row['valor_final']),
          subtotal: parse_decimal(standardized_row['subtotal']),
          discount_percent: standardized_row['desconto_percent']&.to_i || 0,
          sales_channel: standardized_row['canal_venda']&.to_s&.strip&.downcase, # Padronizado para minúsculas
          payment_method: standardized_row['forma_pagamento']&.to_s&.strip&.downcase,
          customer_id: standardized_row['cliente_id']&.to_s&.strip,
          customer_name: standardized_row['nome_cliente']&.to_s&.strip,
          customer_age: standardized_row['idade_cliente']&.to_i,
          customer_gender: standardized_row['genero_cliente']&.to_s&.strip&.upcase, # Padronizado para maiúsculas
          customer_city: standardized_row['cidade_cliente']&.to_s&.strip,
          customer_state: standardized_row['estado_cliente']&.to_s&.strip,
          customer_income: parse_decimal(standardized_row['renda_estimada']),
          product_id: standardized_row['produto_id']&.to_s&.strip,
          product_name: standardized_row['nome_produto']&.to_s&.strip,
          product_category: standardized_row['categoria']&.to_s&.strip&.downcase,
          product_brand: standardized_row['marca']&.to_s&.strip,
          unit_price: parse_decimal(standardized_row['preco_unitario']),
          quantity: standardized_row['quantidade']&.to_i || 1,
          profit_margin: standardized_row['margem_lucro']&.to_i || 0,
          region: standardized_row['regiao']&.to_s&.strip,
          delivery_status: standardized_row['status_entrega']&.to_s&.strip&.downcase,
          delivery_days: standardized_row['tempo_entrega_dias']&.to_i || 0,
          seller_id: standardized_row['vendedor_id']&.to_s&.strip
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
        

        begin
          Date.parse(date_str.to_s)
        rescue

          begin
            Date.strptime(date_str.to_s, "%d/%m/%Y")
          rescue
            nil
          end
        end
      end
      
      def parse_decimal(value)
        return 0.0 if value.to_s.empty?
        

        cleaned = value.to_s.gsub(/[R\$\s]/, '').gsub(',', '.')
        cleaned.to_f
      end
    end
  end
end
