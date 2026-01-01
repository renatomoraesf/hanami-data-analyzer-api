#!/bin/bash

cd /workspaces/hanami-data-analyzer-api

echo "🧪 TESTANDO JSON RESPONSE"

# Parar servidores
pkill -f "hanami" 2>/dev/null

# Iniciar
hanami server --host=0.0.0.0 --port=3000 &
sleep 3

echo "=== TESTE RAIZ (RAW) ==="
RESPONSE_ROOT=$(curl -s http://localhost:3000)
echo "Resposta: '$RESPONSE_ROOT'"
echo "É JSON válido? $(echo "$RESPONSE_ROOT" | jq . 2>/dev/null && echo "✅" || echo "❌")"

echo -e "\n=== TESTE HEALTH (RAW) ==="
RESPONSE_HEALTH=$(curl -s http://localhost:3000/health)
echo "Resposta: '$RESPONSE_HEALTH'"
echo "É JSON válido? $(echo "$RESPONSE_HEALTH" | jq . 2>/dev/null && echo "✅" || echo "❌")"

# Forçar Content-Type
echo -e "\n=== TESTE COM HEADER ACCEPT ==="
curl -s -H "Accept: application/json" http://localhost:3000 | jq . 2>/dev/null || echo "❌ Falha"

pkill -f "hanami" 2>/dev/null
