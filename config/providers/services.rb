# config/providers/services.rb
Hanami.app.register_provider :services do
  prepare do
    # Registrar serviços sem dependências
    require_relative "../../lib/data_analyzer_api/services/mock_data"
    require_relative "../../lib/data_analyzer_api/services/pdf_exporter"
    require_relative "../../lib/data_analyzer_api/services/report_generator"
    
    # MockData não precisa de dependências
    register "data_analyzer_api.services.mock_data", DataAnalyzerApi::Services::MockData
    
    # PdfExporter não precisa de dependências
    register "data_analyzer_api.services.pdf_exporter", DataAnalyzerApi::Services::PdfExporter.new
  end
  
  start do
    # ReportGenerator precisa de mock_data, então registramos depois
    register "data_analyzer_api.services.report_generator" do
      DataAnalyzerApi::Services::ReportGenerator.new(
        mock_data: target["data_analyzer_api.services.mock_data"]
      )
    end
  end
end
