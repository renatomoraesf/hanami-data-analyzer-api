# auto_register: false
require "hanami/action"

module Api
  class Action < Hanami::Action

    format :json
    

    handle_exception StandardError => 500
    

    before do |request, response|
      response.headers["Access-Control-Allow-Origin"] = "*"
      response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
      response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
    end
  end
end
