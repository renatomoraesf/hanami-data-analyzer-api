module Api
  module Actions
    module Home
      class Health < Api::Action
        def handle(request, response)
          response.body = { status: "ok" }.to_json
        end
      end
    end
  end
end
