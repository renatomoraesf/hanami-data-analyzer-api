# lib/data_analyzer_api/services/report_generator.rb
module DataAnalyzerApi
  module Services
    class ReportGenerator
      include Deps[
        "data_analyzer_api.services.mock_data"
      ]
      
      def generate_all_reports

        data = $loaded_data || mock_data.sales_data
        
        {
          sales_summary: calculate_sales_summary(data),
          financial_metrics: calculate_financial_metrics(data),
          products: calculate_products(data)
        }
      end
      
      private
      
      def calculate_sales_summary(data)
        total = data.sum { |d| d[:valor_final].to_f }
        {
          total_vendas: total.round(2),
          numero_transacoes: data.size,
          media_por_transacao: (total / data.size).round(2)
        }
      end
      
      def calculate_financial_metrics(data)
        receita = data.sum { |d| d[:valor_final].to_f }
        custo = receita * 0.6  
        lucro = receita - custo
        
        {
          receita_liquida: receita.round(2),
          custo_total: custo.round(2),
          lucro_bruto: lucro.round(2)
        }
      end
      
      def calculate_products(data)

        products_hash = data.group_by { |d| d[:produto_id] }
        
        products_hash.map do |produto_id, vendas|
          {
            nome: produto_id,
            quantidade: vendas.size,
            total: vendas.sum { |v| v[:valor_final].to_f }.round(2)
          }
        end.sort_by { |p| -p[:total] }
      end
    end
  end
end
