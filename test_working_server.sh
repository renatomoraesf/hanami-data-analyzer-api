#!/bin/bash

cd /workspaces/hanami-data-analyzer-api

echo "🎯 TESTE DO SERVIDOR FUNCIONAL"

# Limpar
echo "1. Limpando servidores antigos..."
pkill -f "puma" 2>/dev/null
pkill -f "hanami" 2>/dev/null
sleep 1

# Testar boot
echo "2. Testando boot Hanami..."
if ! ruby -e "require 'hanami'; require_relative 'config/app'; puts '✅ Boot OK'"; then
    echo "❌ Boot falhou"
    exit 1
fi

# Iniciar servidor
echo "3. Iniciando servidor na porta 4000..."
hanami server --host=0.0.0.0 --port=4000 &
PID=$!
sleep 4

# Testar endpoints
echo "4. Testando endpoints..."
echo "=== RAIZ ==="
curl -s http://localhost:4000
echo -e "\n"

echo "=== HEALTH ==="
curl -s http://localhost:4000/health
echo -e "\n"

# Testar upload endpoint (placeholder)
echo "=== UPLOAD (placeholder) ==="
curl -s -X POST http://localhost:4000/upload \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}' || echo "Endpoint upload retornou erro (esperado)"

echo -e "\n✅ TESTE COMPLETO!"

# Parar servidor
kill $PID 2>/dev/null
