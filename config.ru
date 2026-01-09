# config.ru mínima
require "hanami"

module DataAnalyzerApi
  class App < Hanami::App
  end
end

run DataAnalyzerApi::App.new
