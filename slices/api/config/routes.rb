module Api
  class Routes < Hanami::Routes
    define do
      root to: "home.show"
      post "/upload", to: "uploads.create"
      get "/health", to: "home.health"
    end
  end
end
