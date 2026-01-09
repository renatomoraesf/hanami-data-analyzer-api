module Api
  module Actions
    module Home
      class Health < Api::Action
        def handle(request, response)
          response.body = { 
            status: "healthy",
            timestamp: Time.now.iso8601
          }.to_json
        end
      end
    end
  end
end
