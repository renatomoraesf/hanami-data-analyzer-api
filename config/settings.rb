module DataAnalyzerApi
  class Settings < Hanami::Settings
    setting :database_url, constructor: Types::String
  end
end
