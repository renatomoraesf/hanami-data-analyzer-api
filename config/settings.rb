# config/settings.rb - MÍNIMO
module DataAnalyzerApi
  class Settings < Hanami::Settings
    setting :log_level, default: "info"
  end
end
