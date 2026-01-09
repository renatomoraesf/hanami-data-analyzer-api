module DataAnalyzerApi
  class Routes < Hanami::Routes
    # Rota raiz
    get "/", to: ->(env) { 
      [200, {"Content-Type" => "application/json"}, 
        ['{"api":"Hanami Data Analyzer","version":"1.0","endpoints":["POST /upload","GET /reports/sales-summary","GET /reports/regional-performance","GET /reports/product-analysis","GET /reports/customer-profile","GET /reports/financial-metrics","GET /analytics/trends","GET /data/search"]}']] 
    }
    
    # Health check
    get "/health", to: ->(env) { 
      [200, {"Content-Type" => "application/json"}, ['{"status":"healthy","timestamp":"'$(date -Iseconds)'"}']] 
    }
    
    # Upload de arquivos
    post "/upload", to: "uploads.create"
    
    # Relatórios (Alta Prioridade)
    get "/reports/sales-summary", to: "reports.sales_summary"
    get "/reports/regional-performance", to: "reports.regional_performance"
    get "/reports/product-analysis", to: "reports.product_analysis"
    get "/reports/customer-profile", to: "reports.customer_profile"
    get "/reports/financial-metrics", to: "reports.financial_metrics"
    
    # Analytics (Opcional/Baixa Prioridade)
    get "/analytics/trends", to: "analytics.trends"
    get "/data/search", to: "data.search"
  end
end
