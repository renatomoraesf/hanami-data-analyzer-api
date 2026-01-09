# config/app_minimal.rb (temporário)
require "hanami"

module DataAnalyzerApi
  class App < Hanami::App
    # Configuração absolutamente mínima
    config.logger = nil  # Desabilita logger para testes
    
    # Desabilita slices automáticos
    config.slices = []
    
    # Desabilita settings
    config.settings = nil
  end
end
