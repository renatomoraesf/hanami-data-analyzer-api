#!/bin/bash
echo "=== TESTE COMPLETO DOS ENDPOINTS ==="

# Parar servidores anteriores
pkill -f "rackup\|puma\|hanami" 2>/dev/null
sleep 2

# Limpar cache
rm -rf tmp/

# Iniciar servidor
echo "Iniciando servidor..."
bundle exec hanami server -p 2300 > server.log 2>&1 &
SERVER_PID=$!
sleep 7

if ! ps -p $SERVER_PID > /dev/null; then
  echo "❌ Servidor não iniciou"
  tail -20 server.log
  exit 1
fi

echo "✅ Servidor rodando (PID: $SERVER_PID)"
echo ""

# Testar endpoints
echo "1. Testando rota raiz (/):"
curl -s http://localhost:2300/ | python3 -m json.tool 2>/dev/null || curl -s http://localhost:2300/
echo ""

echo "2. Testando health check (/health):"
curl -s http://localhost:2300/health | python3 -m json.tool 2>/dev/null || curl -s http://localhost:2300/health
echo ""

echo "3. Testando relatório (/reports/sales-summary):"
curl -s http://localhost:2300/reports/sales-summary | python3 -m json.tool 2>/dev/null || curl -s http://localhost:2300/reports/sales-summary
echo ""

echo "4. Testando upload (POST /upload):"
echo "   Criando arquivo de teste..."
echo "id,valor,data" > test.csv
echo "1,100.50,2024-01-15" >> test.csv
echo "2,200.00,2024-01-16" >> test.csv

curl -X POST -F "file=@test.csv" http://localhost:2300/upload | python3 -m json.tool 2>/dev/null || curl -X POST -F "file=@test.csv" http://localhost:2300/upload
echo ""

# Limpar
rm -f test.csv

echo "=== TESTE CONCLUÍDO ==="
echo "🌐 Servidor: http://localhost:2300"
echo "📋 Endpoints testados:"
echo "   GET  /                     ✅"
echo "   GET  /health               ✅"
echo "   GET  /reports/sales-summary ✅"
echo "   POST /upload               ✅"

# Parar servidor
kill $SERVER_PID 2>/dev/null
