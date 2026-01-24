module DataAnalyzerApi
  class Routes < Hanami::Routes

    get "/", to: "home.show"
    

    get "/health", to: "home.health"
    

    post "/upload", to: "uploads.create"
    

    get "/reports/sales-summary", to: "reports.sales_summary"
    get "/reports/regional-performance", to: "reports.regional_performance"
    get "/reports/product-analysis", to: "reports.product_analysis"
    get "/reports/customer-profile", to: "reports.customer_profile"
    get "/reports/financial-metrics", to: "reports.financial_metrics"
    

    get "/analytics/trends", to: "analytics.trends"
    

    get "/data/search", to: "data.search"
  end
end
