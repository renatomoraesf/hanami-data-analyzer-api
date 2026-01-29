# frozen_string_literal: true
require "dry/inflector"

class CustomInflector < Dry::Inflector
  def camelize(string)
    # Tratar o slice 'api' especificamente
    if string == "api"
      "Api"
    elsif string == "data_analyzer_api"
      "DataAnalyzerApi"
    elsif string.end_with?("_api")
      super(string.sub(/_api$/, "_Api"))
    else
      super(string)
    end
  end
  
  def constantize(string)
    # Mapear DataAnalyzerAPI para DataAnalyzerApi
    if string == "DataAnalyzerAPI::Actions"
      Object.const_get("DataAnalyzerApi::Actions")
    elsif string == "API"
      Object.const_get("Api")
    else
      super(string)
    end
  end
end

Hanami.app.register "inflector" do
  CustomInflector.new
end
