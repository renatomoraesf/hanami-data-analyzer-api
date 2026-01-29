module DataAnalyzerApi
  module Services
    class JsonExporter
      def export_full_report
        {
          report: {
            generated_at: Time.now.iso8601,
            status: "success",
            data: {
              sales_summary: fetch_sales_summary,
              financial_metrics: fetch_financial_metrics,
              product_analysis: fetch_product_analysis,
              regional_performance: fetch_regional_performance,
              customer_profile: fetch_customer_profile
            }
          }
        }
      end
      
      private
      
      def fetch_sales_summary
        { total_vendas: 150000.50, media_por_transacao: 250.75, numero_transacoes: 598 }
      end
      
      def fetch_financial_metrics
        { receita_liquida: 180000.00, lucro_bruto: 45000.00, custo_total: 135000.00 }
      end
      
      def fetch_product_analysis
        [
          { nome: "iPhone 15", quantidade: 150, total: 150000.00 },
          { nome: "Samsung S24", quantidade: 100, total: 80000.00 }
        ]
      end
      
      def fetch_regional_performance
        { "Sudeste": { vendas: 90000 }, "Sul": { vendas: 40000 } }
      end
      
      def fetch_customer_profile
        { genero: { "M": 55, "F": 45 }, faixa_etaria: { "18-35": 60, "36+": 40 } }
      end
    end
  end
end
