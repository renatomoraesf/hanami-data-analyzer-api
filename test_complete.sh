#!/bin/bash

cd /workspaces/hanami-data-analyzer-api

echo "🧪 TESTE COMPLETO DO UPLOAD"

# 1. Criar CSV de teste
cat > /tmp/test.csv << 'CSV'
id_transacao,data_venda,valor_final,subtotal,desconto_percent,canal_venda,forma_pagamento,regiao,status_entrega,tempo_entrega_dias,vendedor_id,cliente_id,produto_id
TEST001,2023-01-01,100.00,100.00,0,Online,Cartão Crédito,Sudeste,Entregue,3,VEN001,CLI001,PRD001
TEST002,2023-01-02,200.00,200.00,0,Loja Física,PIX,Sul,Em Trânsito,5,VEN002,CLI002,PRD002
CSV

# 2. Iniciar servidor se não estiver rodando
if ! curl -s http://localhost:3000/health 2>/dev/null | grep -q "ok"; then
    echo "Iniciando servidor na porta 3000..."
    hanami server --host=0.0.0.0 --port=3000 > server.log 2>&1 &
    SERVER_PID=$!
    sleep 5
fi

# 3. Testar health endpoint
echo "Testando health endpoint..."
curl -s http://localhost:3000/health 2>/dev/null | jq . || {
    echo "❌ Health endpoint falhou"
    echo "Tentando porta 3001..."
    hanami server --host=0.0.0.0 --port=3001 > server2.log 2>&1 &
    sleep 3
    curl -s http://localhost:3001/health 2>/dev/null | jq . || echo "❌ Ambas portas falharam"
    exit 1
}

# 4. Testar upload
echo -e "\nTestando upload..."
RESPONSE=$(curl -s -X POST http://localhost:3000/upload \
  -F "file=@/tmp/test.csv" \
  -H "Content-Type: multipart/form-data" \
  --max-time 10)

if [ $? -eq 0 ]; then
    echo "✅ Resposta do servidor:"
    echo "$RESPONSE" | jq .
else
    echo "❌ Falha no upload"
    echo "Logs do servidor:"
    tail -20 server.log 2>/dev/null || tail -20 log/development.log 2>/dev/null
fi

# Limpar
rm -f /tmp/test.csv
[ ! -z "$SERVER_PID" ] && kill $SERVER_PID 2>/dev/null || true
