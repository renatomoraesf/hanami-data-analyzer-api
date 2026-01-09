module Api
  module Actions
    module Home
      class Show < Api::Action
        def handle(request, response)
          response.body = { 
            api: "Data Analyzer API", 
            version: "1.0",
            status: "online",
            endpoints: ["/health", "/upload", "/reports/sales-summary"]
          }.to_json
        end
      end
    end
  end
end
