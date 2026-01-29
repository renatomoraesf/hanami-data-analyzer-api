# config/routes.rb
require "hanami/routes"

module DataAnalyzerApi
  class Routes < Hanami::Routes
    # Rotas da API
    slice :api, at: "/api" do
      post "/uploads", to: "uploads.create"
      get  "/reports/download", to: "reports.download"
    end
    
    # Rota raiz
    slice :api, at: "/" do
      get "/", to: "home.health"
    end
  end
end
