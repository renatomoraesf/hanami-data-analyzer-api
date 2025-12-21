module Api
  module Actions
    module Home
      class Show < Api::Action
        def handle(request, response)
          response.body = { 
            message: "Hanami Data Analyzer API",
            version: "1.0.0",
            endpoints: {
              upload: "POST /upload",
              sales_summary: "GET /reports/sales-summary",
              regional_performance: "GET /reports/regional-performance",
              product_analysis: "GET /reports/product-analysis",
              customer_profile: "GET /reports/customer-profile",
              financial_metrics: "GET /reports/financial-metrics"
            }
          }.to_json
        end
      end
    end
  end
end
