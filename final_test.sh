#!/bin/bash

cd /workspaces/hanami-data-analyzer-api

echo "🎯 TESTE DEFINITIVO"

# Limpar
pkill -f "hanami" 2>/dev/null

# Iniciar modo verbose
hanami server --host=0.0.0.0 --port=3000 > hanami.log 2>&1 &
PID=$!
sleep 5

echo "=== VERIFICANDO SERVIDOR ==="
if curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 | grep -q "200"; then
    echo "✅ Servidor HTTP 200 OK"
else
    echo "❌ Servidor não responde 200"
    echo "Logs:"
    tail -10 hanami.log
    kill $PID
    exit 1
fi

echo -e "\n=== TESTANDO RESPONSE ==="
echo "1. Resposta raiz:"
curl -s -H "Accept: application/json" http://localhost:3000
echo -e "\n"

echo "2. Headers da resposta:"
curl -s -I http://localhost:3000 | grep -i "content-type"

echo -e "\n3. Teste com jq:"
curl -s -H "Accept: application/json" http://localhost:3000 | jq . 2>/dev/null && echo "✅ JSON válido" || {
    echo "❌ JSON inválido"
    echo "Resposta crua:"
    curl -s http://localhost:3000 | cat -A
}

echo -e "\n4. Health endpoint:"
curl -s -H "Accept: application/json" http://localhost:3000/health | jq . 2>/dev/null || echo "❌ Health falhou"

kill $PID 2>/dev/null
