# auto_register: false
require "hanami/action"

module Api
  class Action < Hanami::Action
    format :json
    
    private
    
    def json_params
      request.params.to_h
    end
    
    def handle_validation_errors(errors)
      halt 422, { errors: errors.to_h }.to_json
    end
  end
end
