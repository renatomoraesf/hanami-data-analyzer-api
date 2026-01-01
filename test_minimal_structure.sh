#!/bin/bash

cd /workspaces/hanami-data-analyzer-api

echo "🧪 TESTANDO ESTRUTURA MÍNIMA"

# Parar tudo
pkill -f "hanami" 2>/dev/null

# Testar boot
echo "1. Testando boot..."
if ruby -e "
  require 'hanami'
  require_relative 'config/app'
  puts '✅ Boot OK'
  puts 'App preparado? ' + DataAnalyzerApi::App.key?(:routes).to_s
"; then
    echo "✅ Boot funciona"
else
    echo "❌ Boot falhou"
    exit 1
fi

# Iniciar servidor
echo -e "\n2. Iniciando servidor..."
hanami server --host=0.0.0.0 --port=3000 > server.log 2>&1 &
PID=$!
sleep 5

# Testar
echo "3. Testando endpoints..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 | grep -q "200"; then
    echo "✅ Servidor HTTP 200 OK"
    echo "Resposta:"
    curl -s http://localhost:3000 | jq . 2>/dev/null || curl -s http://localhost:3000
    
    echo -e "\nHealth endpoint:"
    curl -s http://localhost:3000/health | jq . 2>/dev/null || curl -s http://localhost:3000/health
else
    echo "❌ Servidor não responde"
    echo "Logs:"
    tail -20 server.log
fi

kill $PID 2>/dev/null
