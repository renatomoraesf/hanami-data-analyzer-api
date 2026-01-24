require "hanami"

module DataAnalyzerApi
  class App < Hanami::App
    # Configuração básica
    config.slices = %w[api]
    
    # Configurações de ambiente
    environment :development do
      config.logger.level = :debug
    end
    
    environment :production do
      config.logger.level = :info
    end
  end
end
