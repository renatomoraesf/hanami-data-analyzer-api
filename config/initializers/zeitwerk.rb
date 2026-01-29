# config/initializers/zeitwerk.rb
# Forçar carregamento de settings antes do autoload
if defined?(Hanami) && Hanami.app?
  # Já carregamos no app.rb, mas garantir
  require_relative "../settings" unless defined?(DataAnalyzerApi::Settings)
end
