# auto_register: false
module Api
  module Actions
    module Uploads
      class Create < Api::Action
        def handle(request, response)
          response.body = { message: "Upload endpoint working!" }.to_json
        end
      end
    end
  end
end
