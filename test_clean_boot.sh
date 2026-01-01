#!/bin/bash

cd /workspaces/hanami-data-analyzer-api

echo "🧹 BOOT LIMPO"

# Remover settings.rb problemático
rm -f config/settings.rb 2>/dev/null

# Testar boot
echo "Testando boot..."
ruby -e "
begin
  require 'hanami'
  require_relative 'config/app'
  puts '✅ Hanami carregado'
  puts 'App: #{DataAnalyzerApi::App.name}'
  
  # Verificar slices
  if defined?(DataAnalyzerApi::App.slices)
    puts 'Slices: #{DataAnalyzerApi::App.slices.keys}'
  end
rescue => e
  puts '❌ Erro: #{e.message}'
  puts 'Backtrace:'
  puts e.backtrace.first(3)
  exit 1
end
"

# Testar servidor
echo -e "\nTestando servidor..."
hanami server --host=0.0.0.0 --port=3001 &
PID=$!
sleep 4

if curl -s http://localhost:3001 > /dev/null; then
    echo "✅ Servidor funciona"
    echo "Resposta raiz:"
    curl -s http://localhost:3001
    echo -e "\nHealth:"
    curl -s http://localhost:3001/health
else
    echo "❌ Servidor não responde"
fi

kill $PID 2>/dev/null
