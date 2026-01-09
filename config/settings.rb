# config/settings.rb
module DataAnalyzerApi
  class Settings < Hanami::Settings
    # Configurações do banco de dados
    setting :database_url, constructor: Types::String
    
    # API settings
    setting :max_upload_size, constructor: Types::Integer.default(50 * 1024 * 1024)
    setting :max_upload_size, constructor: Types::Params::Integer, default: 10_485_760 # 10MB
    setting :cors_origins, constructor: Types::String, default: "*"  # 50MB
    
    # Configurações gerais
    setting :dev_secret, constructor: Types::String, default: "dev_secret".freeze
    setting :info, constructor: Types::String, default: "info".freeze
    
    # CORS
    setting :cors_origins, constructor: Types::String.default("*")
  end
end
