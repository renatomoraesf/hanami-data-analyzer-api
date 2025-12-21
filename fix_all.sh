#!/bin/bash

cd /workspaces/hanami-data-analyzer-api

echo "🔧 CORRIGINDO TUDO..."

# 1. Verificar PostgreSQL
echo "1. Verificando PostgreSQL..."
sudo -u postgres psql -c "\c data_analyzer_api_dev" -c "\dt" 2>/dev/null && {
    echo "✅ PostgreSQL OK"
} || {
    echo "❌ PostgreSQL falhou, criando tabelas..."
    sudo -u postgres psql << 'SQL'
\c data_analyzer_api_dev
CREATE TABLE IF NOT EXISTS sales (id SERIAL PRIMARY KEY, id_transacao VARCHAR(50) UNIQUE NOT NULL);
CREATE TABLE IF NOT EXISTS customers (id SERIAL PRIMARY KEY, cliente_id VARCHAR(50) UNIQUE NOT NULL);
CREATE TABLE IF NOT EXISTS products (id SERIAL PRIMARY KEY, produto_id VARCHAR(50) UNIQUE NOT NULL);
SQL
}

# 2. Configurar Hanami
echo "2. Configurando Hanami..."
[ -f "config/providers/persistence.rb" ] || {
    mkdir -p config/providers
    cat > config/providers/persistence.rb << 'PROVIDER'
Hanami.app.register_provider :persistence, namespace: true do
  prepare do
    require "rom"
    config = ROM::Configuration.new(:sql, ENV['DATABASE_URL'] || "postgresql://hanami:hanami123@localhost:5432/data_analyzer_api_dev")
    register "config", config
  end

  start do
    config = target["persistence.config"]
    register "rom", ROM.container(config)
  end
end
PROVIDER
}

# 3. Criar .env
echo "3. Configurando .env..."
cat > .env << 'ENV'
DATABASE_URL="postgresql://hanami:hanami123@localhost:5432/data_analyzer_api_dev"
HANAMI_ENV="development"
ENV

# 4. Testar
echo "4. Testando..."
bundle exec hanami console << 'CONSOLE'
begin
  require "hanami/app"
  Hanami.app.boot
  
  if defined?(Hanami.app["persistence.rom"])
    puts "✅ persistence.rom encontrado"
    tables = Hanami.app["persistence.rom"].gateway.connection.tables rescue []
    puts "Tabelas: #{tables}"
  else
    puts "❌ persistence.rom não configurado"
    puts "Providers: #{Hanami.app.registered_providers}"
  end
rescue => e
  puts "Erro: #{e.message}"
  puts e.backtrace.first(5).join("\n")
end
CONSOLE

echo ""
echo "�� PRÓXIMOS PASSOS:"
echo "1. Implementar endpoint: hanami generate action api.uploads.create --url=/upload --method=POST"
echo "2. Iniciar servidor: hanami server --host=0.0.0.0 --port=3000"
