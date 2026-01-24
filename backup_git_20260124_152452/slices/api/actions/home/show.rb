module Api
  module Actions
    module Home
      class Show < Api::Action
        def handle(request, response)
          response.format = :json
          response.body = {
            api: "Hanami Data Analyzer API",
            version: "1.0",
            status: "online",
            endpoints: [
              "POST /upload",
              "GET /reports/sales-summary",
              "GET /reports/regional-performance",
              "GET /reports/product-analysis",
              "GET /reports/customer-profile",
              "GET /reports/financial-metrics",
              "GET /analytics/trends",
              "GET /data/search"
            ],
            documentation: "Veja README.md para detalhes",
            timestamp: Time.now.iso8601
          }.to_json
        end
      end
    end
  end
end
