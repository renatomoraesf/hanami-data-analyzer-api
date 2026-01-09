#!/bin/bash
echo "🔍 Verificação Rápida da Sprint 1"
echo ""

echo "1. Verificando servidor..."
if curl -s http://localhost:2300/ > /dev/null 2>&1; then
    echo "✅ Servidor rodando em http://localhost:2300"
else
    echo "❌ Servidor não está respondendo"
    echo "   Inicie com: bundle exec hanami server -p 2300"
    exit 1
fi

echo ""
echo "2. Testando endpoints principais:"

endpoints=(
    "/"
    "/health"
    "/reports/sales-summary"
    "/reports/product-analysis"
    "/reports/financial-metrics"
)

for endpoint in "${endpoints[@]}"; do
    if curl -s -f "http://localhost:2300$endpoint" > /dev/null 2>&1; then
        echo "✅ GET $endpoint"
    else
        echo "❌ GET $endpoint (falhou)"
    fi
done

echo ""
echo "3. Verificando estrutura do projeto:"

required_files=(
    "config/app.rb"
    "config/routes.rb"
    "slices/api/actions/uploads/create.rb"
    "slices/api/actions/reports/sales_summary.rb"
    "slices/api/actions/reports/product_analysis.rb"
    "slices/api/actions/reports/financial_metrics.rb"
    "lib/data_analyzer_api/services/csv_processor.rb"
    "README.md"
)

missing_files=0
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file (faltando)"
        ((missing_files++))
    fi
done

echo ""
echo "📊 RESUMO:"
echo "Endpoints testados: ${#endpoints[@]}"
echo "Arquivos verificados: ${#required_files[@]}"
echo "Arquivos faltando: $missing_files"

if [ $missing_files -eq 0 ]; then
    echo "🎉 Sprint 1 parece estar bem estruturada!"
    echo "Execute './verify_sprint1.rb' para verificação completa."
else
    echo "⚠️  Alguns arquivos estão faltando."
    echo "Corrija antes de prosseguir para verificação completa."
fi
