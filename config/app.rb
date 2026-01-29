# config/app.rb
require "hanami"
require "rack/cors"

module DataAnalyzerApi
  class App < Hanami::App
    # Servir arquivos estáticos
    config.middleware.use Rack::Static,
      urls: ["/swagger-ui.html", "/openapi.json"],
      root: "public",
      index: "swagger-ui.html"
    
    # Configurar CORS
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          expose: ['Content-Disposition']
      end
    end
  end
end
