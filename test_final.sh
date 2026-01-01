#!/bin/bash

cd /workspaces/hanami-data-analyzer-api

echo "🎯 TESTE FINAL DO HANAMI"

# 1. Parar servidores
pkill -f "hanami" 2>/dev/null
pkill -f "puma" 2>/dev/null

# 2. Testar boot
echo "Testando boot..."
if ruby -e "require 'hanami'; require_relative 'config/app'; puts '✅ Boot OK'"; then
    echo "✅ Boot funciona"
else
    echo "❌ Boot falhou"
    exit 1
fi

# 3. Iniciar servidor
echo "Iniciando servidor..."
hanami server --host=0.0.0.0 --port=3000 > server.log 2>&1 &
PID=$!
sleep 5

# 4. Testar
echo "Testando endpoints..."
if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ Servidor responde"
    echo "=== RESPOSTA RAIZ ==="
    curl -s http://localhost:3000 | jq .
    
    echo -e "\n=== HEALTH ENDPOINT ==="
    curl -s http://localhost:3000/health | jq .
    
    echo -e "\n🎉 TUDO FUNCIONANDO!"
    
    # Matar servidor
    kill $PID 2>/dev/null
else
    echo "❌ Servidor não responde"
    echo "Logs:"
    tail -20 server.log
    kill $PID 2>/dev/null
    exit 1
fi
