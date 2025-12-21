module DataAnalyzerApi
  class Routes < Hanami::Routes
    root to: "home.show"
    
    # Upload endpoint
    post "/upload", to: "uploads.create"
    
    # Reports endpoints (a implementar)
    get "/reports/sales-summary", to: "reports.sales_summary"
    get "/reports/regional-performance", to: "reports.regional_performance"
    get "/reports/product-analysis", to: "reports.product_analysis"
    get "/reports/customer-profile", to: "reports.customer_profile"
    get "/reports/financial-metrics", to: "reports.financial_metrics"
  end
end
