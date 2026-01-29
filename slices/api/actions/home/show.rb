# slices/api/actions/home/show.rb
require "hanami/action"

module Api
  module Actions
    module Home
      class Show < Hanami::Action
        def handle(request, response)
          response.status = 200
          response.headers["Content-Type"] = "application/json"
          response.body = {
            app: "Hanami Data Analyzer API",
            version: "1.0.0",
            status: "running",
            endpoints: {
              upload: "POST /api/uploads",
              download: "GET /api/reports/download?format=json|pdf",
              documentation: "/openapi.json"
            },
            timestamp: Time.now.iso8601
          }.to_json
        end
      end
    end
  end
end
