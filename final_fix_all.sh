#!/bin/bash

cd /workspaces/hanami-data-analyzer-api

echo "🔧 CORREÇÃO FINAL COMPLETA"

# 1. Limpar estrutura problemática
echo "1. Limpando estrutura..."
rm -rf slices/ 2>/dev/null
rm -f config/settings.rb 2>/dev/null

# 2. Configuração mínima
echo "2. Configurando app..."
cat > config/app.rb << 'APP'
require "hanami"

module DataAnalyzerApi
  class App < Hanami::App
    config.actions.format :json
    config.logger.level = :info
  end
end
APP

cat > config.ru << 'RACK'
require_relative "config/app"
run DataAnalyzerApi::App
RACK

# 3. Criar slice API
echo "3. Criando slice API..."
mkdir -p slices/api/actions/{home,uploads}
mkdir -p slices/api/config

# Action base
cat > slices/api/action.rb << 'ACTION'
module Api
  class Action < Hanami::Action
    format :json
  end
end
ACTION

# Home actions
cat > slices/api/actions/home/show.rb << 'HOME'
module Api
  module Actions
    module Home
      class Show < Api::Action
        def handle(request, response)
          response.body = { api: "Data Analyzer API", status: "online" }.to_json
        end
      end
    end
  end
end
HOME

cat > slices/api/actions/home/health.rb << 'HEALTH'
module Api
  module Actions
    module Home
      class Health < Api::Action
        def handle(request, response)
          response.body = { status: "ok" }.to_json
        end
      end
    end
  end
end
HEALTH

# Routes
cat > slices/api/config/routes.rb << 'ROUTES'
module Api
  class Routes < Hanami::Routes
    define do
      root to: "home.show"
      post "/upload", to: "uploads.create"
      get "/health", to: "home.health"
    end
  end
end
ROUTES

# 4. Testar
echo "4. Testando..."
if ruby -e "require 'hanami'; require_relative 'config/app'; puts '✅ Boot OK'"; then
    echo "✅ Boot funciona"
    
    # Testar servidor
    timeout 5 hanami server --host=0.0.0.0 --port=3002 > /tmp/test.log 2>&1 &
    sleep 3
    
    if curl -s http://localhost:3002 > /dev/null; then
        echo "🎉 SUCESSO! Servidor responde"
        echo "Raiz:"
        curl -s http://localhost:3002
        echo -e "\nHealth:"
        curl -s http://localhost:3002/health
    else
        echo "⚠️  Servidor não iniciou"
        echo "Logs:"
        tail -5 /tmp/test.log
    fi
else
    echo "❌ Boot falhou"
    exit 1
fi
