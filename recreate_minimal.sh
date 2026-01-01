#!/bin/bash

cd /workspaces/hanami-data-analyzer-api

echo "🔄 RECRIANDO ESTRUTURA MÍNIMA FUNCIONAL"

# Backup dos nossos arquivos importantes
mkdir -p /tmp/hanami_core
cp -r lib/data_analyzer_api /tmp/hanami_core/ 2>/dev/null || true

# Limpar estrutura problemática
rm -rf config/app.rb config/routes.rb config.ru apps/ slices/ 2>/dev/null || true

# Criar estrutura mínima do Hanami 2.3
cat > config/app.rb << 'APP'
require "hanami"

module DataAnalyzerApi
  class App < Hanami::App
    config.actions.format :json
    
    # Configurar slice API
    register_slice :api
  end
end

# Preparar app
DataAnalyzerApi::App.prepare
APP

cat > config.ru << 'RACK'
require_relative "config/app"
run DataAnalyzerApi::App
RACK

# Criar slice API
mkdir -p slices/api/actions/home
mkdir -p slices/api/actions/uploads

# Action base do slice
cat > slices/api/action.rb << 'ACTION'
module Api
  class Action < Hanami::Action
    format :json
  end
end
ACTION

# Home action simples
cat > slices/api/actions/home/show.rb << 'HOME'
module Api
  module Actions
    module Home
      class Show < Api::Action
        def handle(request, response)
          response.body = { message: "API Online" }.to_json
        end
      end
    end
  end
end
HOME

# Health action
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

# Routes do slice
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

echo "✅ Estrutura recreada"
