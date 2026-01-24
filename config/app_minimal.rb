# config/app_minimal.rb (temporário)
require "hanami"

module DataAnalyzerApi
  class App < Hanami::App

    config.logger = nil  
    

    config.slices = []
    

    config.settings = nil
  end
end
