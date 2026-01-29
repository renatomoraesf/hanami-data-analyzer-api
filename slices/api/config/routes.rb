# slices/api/config/routes.rb
module API
  class Routes < Hanami::Routes

    post "/uploads", to: "uploads.create"
    get "/reports/download", to: "reports.download"
  end
end