Hanami.app.register_provider(:data_store) do
  start do
    require "hanami_data_analyzer/services/data_store"
    
    register "data_store", HanamiDataAnalyzer::Services::DataStore.new
  end
end

Hanami.app.register_provider(:reports) do
  start do
    require "hanami_data_analyzer/services/reports/sales_summary"
    
    register "reports.sales_summary", DataAnalyzerApi::Services::Reports::SalesSummary
  end
end