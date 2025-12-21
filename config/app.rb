require "hanami"

module DataAnalyzerApi
  class App < Hanami::App
    config.actions.format :json
    
    config.middleware.use :body_parser, :json
    
    environment :development do
      config.logger.stream = File.new("log/development.log", "a+")
      config.logger.level = :debug
    end
  end
end
