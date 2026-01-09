# frozen_string_literal: true

require "dry/inflector"

# Crie um inflector personalizado que NÃO inflete "Api" para "API"
class CustomInflector < Dry::Inflector
  def camelize(string)
    # Se for exatamente "data_analyzer_api", converta para "DataAnalyzerApi"
    if string == "data_analyzer_api"
      "DataAnalyzerApi"
    elsif string.end_with?("_api")
      # Para strings terminando com _api, mantenha Api
      super(string.sub(/_api$/, "_Api"))
    else
      super(string)
    end
  end
  
  def constantize(string)
    # Sobrescreva também a constante
    if string == "DataAnalyzerAPI::Actions"
      Object.const_get("DataAnalyzerApi::Actions")
    else
      super(string)
    end
  end
end

Hanami.app.register "inflector" do
  CustomInflector.new
end
