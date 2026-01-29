# config/providers.rb
Hanami.app.register_provider(:data_store) do
  start do
    require "data_analyzer_api/services/data_store"
    register "data_store", DataAnalyzerApi::Services::DataStore.new
  end
end

Hanami.app.register_provider(:json_exporter) do
  start do
    require "data_analyzer_api/services/json_exporter"
    register "json_exporter", DataAnalyzerApi::Services::JsonExporter.new
  end
end

Hanami.app.register_provider(:pdf_exporter) do
  start do
    require "data_analyzer_api/services/pdf_exporter"
    register "pdf_exporter", DataAnalyzerApi::Services::PdfExporter.new
  end
end
