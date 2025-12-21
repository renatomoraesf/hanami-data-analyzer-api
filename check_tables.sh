#!/bin/bash

echo "📊 VERIFICANDO TABELAS (múltiplos métodos)"

echo "1. Método TCP com senha:"
PGPASSWORD=hanami123 psql -h localhost -U hanami -d data_analyzer_api_dev -c "\dt" 2>/dev/null || echo "❌ Falhou"

echo -e "\n2. Método como postgres:"
sudo -u postgres psql -d data_analyzer_api_dev -c "\dt" 2>/dev/null || echo "❌ Falhou"

echo -e "\n3. Método via URI:"
psql "postgresql://hanami:hanami123@localhost:5432/data_analyzer_api_dev" -c "\dt" 2>/dev/null || echo "❌ Falhou"

echo -e "\n4. Verificar via Hanami:"
cd /workspaces/hanami-data-analyzer-api
hanami console << 'CONSOLE'
begin
  puts "Tabelas: #{Hanami.app['persistence.rom'].gateway.connection.tables}"
rescue => e
  puts "Erro: #{e.message}"
end
CONSOLE
