module Api
  module Actions
    module Home
      class Show < Api::Action
        def handle(request, response)
          response.body = { api: "Data Analyzer API", status: "online" }.to_json
        end
      end
    end
  end
end
