module DataAnalyzerApi
  module Services
    class JsonExporter
      def initialize(sales_repo, calculators)
        @sales_repo = sales_repo
        @calculators = calculators
      end

      def export_full_report
        {
          report: {
            generated_at: Time.now.iso8601,
            summary: generate_summary,
            products: generate_product_analysis,
            finance: generate_financial_metrics,
            regions: generate_regional_performance,
            customers: generate_customer_profile
          }
        }
      end

      private

      def generate_summary

      end
      
    end
  end
end