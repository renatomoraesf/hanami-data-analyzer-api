module DataAnalyzerApi
  module Services
    class CsvParser
      def call(file_path)
        require 'csv'
        
        data = { sales: [], customers: [], products: [] }
        
        CSV.foreach(file_path, headers: true, encoding: 'UTF-8') do |row|
          sale_data, customer_data, product_data = process_row(row)
          
          data[:sales] << sale_data if sale_data
          data[:customers] << customer_data if customer_data
          data[:products] << product_data if product_data
        end
        
        data
      rescue => e
        raise ParsingError, "Failed to parse CSV: #{e.message}"
      end
      
      private
      
      def process_row(row)

        sale_data = {
          id_transacao: safe_strip(row['id_transacao']),
          data_venda: parse_date(row['data_venda']),
          valor_final: safe_float(row['valor_final']),
          subtotal: safe_float(row['subtotal']),
          desconto_percent: safe_float(row['desconto_percent']),
          canal_venda: safe_strip(row['canal_venda']),
          forma_pagamento: safe_strip(row['forma_pagamento']),
          regiao: safe_strip(row['regiao']),
          status_entrega: safe_strip(row['status_entrega']),
          tempo_entrega_dias: safe_int(row['tempo_entrega_dias']),
          vendedor_id: safe_strip(row['vendedor_id']),
          cliente_id: safe_strip(row['cliente_id']),
          produto_id: safe_strip(row['produto_id']),
          created_at: Time.now,
          updated_at: Time.now
        }
        

        customer_data = if row['nome_cliente'] || row['idade_cliente']
          {
            cliente_id: safe_strip(row['cliente_id']),
            nome_cliente: safe_strip(row['nome_cliente']),
            idade_cliente: safe_int(row['idade_cliente']),
            genero_cliente: safe_strip(row['genero_cliente']),
            cidade_cliente: safe_strip(row['cidade_cliente']),
            estado_cliente: safe_strip(row['estado_cliente']),
            renda_estimada: safe_float(row['renda_estimada']),
            created_at: Time.now,
            updated_at: Time.now
          }
        end
        

        product_data = if row['nome_produto'] || row['categoria']
          {
            produto_id: safe_strip(row['produto_id']),
            nome_produto: safe_strip(row['nome_produto']),
            categoria: safe_strip(row['categoria']),
            marca: safe_strip(row['marca']),
            preco_unitario: safe_float(row['preco_unitario']),
            quantidade: safe_int(row['quantidade']),
            margem_lucro: safe_float(row['margem_lucro']),
            created_at: Time.now,
            updated_at: Time.now
          }
        end
        
        [sale_data, customer_data, product_data]
      end
      
      def safe_strip(value)
        value.to_s.strip if value
      end
      
      def safe_float(value)
        value.to_s.gsub(',', '.').to_f if value && !value.to_s.empty?
      end
      
      def safe_int(value)
        value.to_i if value && !value.to_s.empty?
      end
      
      def parse_date(date_str)
        return nil unless date_str
        Date.parse(date_str.strip)
      rescue
        nil
      end
      
      class ParsingError < StandardError; end
    end
  end
end
