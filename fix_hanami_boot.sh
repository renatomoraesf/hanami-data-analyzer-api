#!/bin/bash

cd /workspaces/hanami-data-analyzer-api

echo "🔧 CORRIGINDO BOOT DO HANAMI"

# 1. Configurações básicas
echo "1. Configurando arquivos básicos..."
cat > config.ru << 'CONFIG'
require "hanami/boot"
run Hanami.app
CONFIG

cat > config/app.rb << 'APP'
require "hanami"
module DataAnalyzerApi
  class App < Hanami::App
    config.actions.format :json
    config.logger = Hanami::Logger.new(level: :info)
  end
end
APP

# 2. Verificar estrutura
echo "2. Verificando estrutura..."
mkdir -p apps/api/actions/{home,uploads,reports}
mkdir -p lib/data_analyzer_api/{services,validators,persistence/repositories}

# 3. Testar boot simples
echo "3. Testando boot..."
ruby -r hanami/boot -e "puts '✅ Hanami boot OK'" 2>&1 || {
    echo "❌ Hanami boot falhou"
    echo "Instalando dependências..."
    bundle install
}

# 4. Testar servidor
echo "4. Testando servidor..."
timeout 10 hanami server --host=0.0.0.0 --port=3001 &
SERVER_PID=$!
sleep 3

if curl -s http://localhost:3001 > /dev/null 2>&1; then
    echo "✅ Servidor funciona na porta 3001"
    kill $SERVER_PID 2>/dev/null
else
    echo "❌ Servidor falhou, verificando logs..."
    kill $SERVER_PID 2>/dev/null
    hanami server --host=0.0.0.0 --port=3002 &
    sleep 2
    curl -s http://localhost:3002 || echo "Falha completa"
fi
