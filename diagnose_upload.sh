#!/bin/bash

cd /workspaces/hanami-data-analyzer-api

echo "🔍 DIAGNÓSTICO DO UPLOAD"

echo "1. Servidor rodando?"
curl -s http://localhost:3000/health 2>/dev/null | jq .status || echo "❌ Servidor não responde"

echo -e "\n2. Tabelas existem?"
PGPASSWORD=hanami123 psql -h localhost -U hanami -d data_analyzer_api_dev -c "\dt" 2>/dev/null || echo "❌ Não conseguiu conectar"

echo -e "\n3. Action existe?"
[ -f "apps/api/actions/uploads/create.rb" ] && echo "✅ Sim" || echo "❌ Não"

echo -e "\n4. Services existem?"
[ -f "lib/data_analyzer_api/services/csv_parser.rb" ] && echo "✅ CSV Parser" || echo "❌ CSV Parser"
[ -f "lib/data_analyzer_api/validators/csv_validator.rb" ] && echo "✅ CSV Validator" || echo "❌ CSV Validator"

echo -e "\n5. Repositories existem?"
find lib/data_analyzer_api/persistence -name "*.rb" | wc -l | xargs echo "Arquivos:"

echo -e "\n6. CSV de teste existe?"
[ -f "test_upload.csv" ] && echo "✅ Sim - $(wc -l test_upload.csv | cut -d' ' -f1) linhas" || echo "❌ Não"

echo -e "\n🎯 PARA TESTAR MANUALMENTE:"
echo "curl -X POST http://localhost:3000/upload \\"
echo "  -F \"file=@test_upload.csv\" \\"
echo "  -H \"Content-Type: multipart/form-data\""
