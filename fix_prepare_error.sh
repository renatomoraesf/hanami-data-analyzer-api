#!/bin/bash

cd /workspaces/hanami-data-analyzer-api

echo "🔧 CORRIGINDO ERRO DE PREPARE"

# 1. Corrigir config/app.rb
echo "1. Corrigindo config/app.rb..."
cat > config/app.rb << 'APP'
require "hanami"

module DataAnalyzerApi
  class App < Hanami::App
    config.actions.format :json
    config.logger.level = :info
    
    environment :development do
      config.logger.stream = $stdout
    end
  end
end

# PREPARAR É OBRIGATÓRIO
DataAnalyzerApi::App.prepare
APP

# 2. Corrigir config.ru
echo "2. Corrigindo config.ru..."
cat > config.ru << 'RACK'
require_relative "config/app"
run DataAnalyzerApi::App
RACK

# 3. Testar
echo "3. Testando..."
if ruby -e "
  require 'hanami'
  require_relative 'config/app'
  puts '✅ App: ' + DataAnalyzerApi::App.name
  puts '✅ Preparado? ' + DataAnalyzerApi::App.key?(:router).to_s
  puts '✅ Slices: ' + DataAnalyzerApi::App.slices.keys.inspect
"; then
    echo "✅ Boot funciona!"
    
    # 4. Testar servidor
    echo "4. Testando servidor..."
    pkill -f "hanami" 2>/dev/null
    hanami server --host=0.0.0.0 --port=4002 > server.log 2>&1 &
    sleep 4
    
    if curl -s http://localhost:4002 > /dev/null; then
        echo "🎉 SUCESSO TOTAL!"
        echo "=== RESPOSTA ==="
        curl -s http://localhost:4002 | jq . 2>/dev/null || curl -s http://localhost:4002
        echo -e "\n=== HEALTH ==="
        curl -s http://localhost:4002/health | jq . 2>/dev/null || curl -s http://localhost:4002/health
    else
        echo "⚠️  Servidor não responde"
        echo "Logs:"
        tail -10 server.log
    fi
else
    echo "❌ Boot ainda falha"
    exit 1
fi
