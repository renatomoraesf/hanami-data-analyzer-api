require "hanami"

module DataAnalyzerApi
  class App < Hanami::App
    config.actions.format :json
    config.logger.level = :info
    
    environment :development do
      config.logger.stream = $stdout
    end
  end
end

# PREPARAR É OBRIGATÓRIO
DataAnalyzerApi::App.prepare
