require "hanami"
module DataAnalyzerApi
  class App < Hanami::App
  end
end

    # Configuração de logging
    config.logger = Hanami::Logger.new(
      "data_analyzer_api",
      level: :debug,
      stream: $stdout,
      formatter: :json
    )
    
    config.logger_options = {
      colorize: Hanami.env == :development,
      filters: ["password", "secret", "token"]
    }
