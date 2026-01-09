#!/bin/bash
echo "=== SETUP DO BANCO DE DADOS ==="

# Verificar PostgreSQL
if ! command -v psql &> /dev/null; then
  echo "❌ PostgreSQL não está instalado"
  exit 1
fi

echo "1. Criando banco de dados..."
# Tentar criar banco (pode falhar se já existir)
createdb data_analyzer_development 2>/dev/null && echo "  ✅ Banco criado" || echo "  ⚠️ Banco já existe ou erro"

echo "2. Executando migrations..."
# Usar o CLI do hanami-db se disponível
if bundle exec hanami db version 2>/dev/null; then
  bundle exec hanami db create
  bundle exec hanami db migrate
  echo "  ✅ Migrations executadas"
else
  echo "  ⚠️ CLI do hanami-db não disponível"
  echo "  Execute manualmente: bundle exec hanami db create && bundle exec hanami db migrate"
fi

echo "3. Verificando conexão..."
# Testar conexão simples
ruby -e "
require 'pg'
begin
  conn = PG.connect(dbname: 'data_analyzer_development')
  puts '  ✅ Conexão com PostgreSQL OK'
  puts \"  Versão: #{conn.exec('SELECT version()').first['version'].split(' ').first(3).join(' ')}\"
  conn.close
rescue => e
  puts '  ❌ Erro na conexão: ' + e.message
end
"

echo "4. Testando estrutura..."
# Verificar se as tabelas foram criadas
ruby -e "
require 'pg'
begin
  conn = PG.connect(dbname: 'data_analyzer_development')
  tables = conn.exec(\"SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'\").map { |r| r['table_name'] }
  puts '  ✅ Tabelas no banco: ' + tables.join(', ')
  conn.close
rescue => e
  puts '  ❌ Erro: ' + e.message
end
"

echo "=== SETUP CONCLUÍDO ==="
