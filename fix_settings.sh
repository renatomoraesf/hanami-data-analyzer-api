#!/bin/bash

cd /workspaces/hanami-data-analyzer-api

echo "🔧 CORRIGINDO CONFIG/SETTINGS"

# 1. Remover ou corrigir settings.rb
if [ -f "config/settings.rb" ]; then
    echo "Arquivo settings.rb encontrado"
    # Verificar conteúdo
    head -5 config/settings.rb
    
    # Criar versão corrigida
    cat > config/settings.rb << 'SETTINGS'
module DataAnalyzerApi
  class Settings < Hanami::Settings
    setting :database_url
  end
end
SETTINGS
    echo "✅ config/settings.rb corrigido"
else
    echo "Criando config/settings.rb simples..."
    cat > config/settings.rb << 'SETTINGS'
module DataAnalyzerApi
  class Settings < Hanami::Settings
    setting :database_url
  end
end
SETTINGS
fi

# 2. Testar boot
echo -e "\nTestando boot..."
if ruby -e "
  begin
    require 'hanami'
    require_relative 'config/app'
    puts '✅ Boot OK'
  rescue => e
    puts '❌ Erro: ' + e.message
    exit 1
  end
"; then
    echo "✅ Tudo funcionando!"
else
    echo "❌ Falha, removendo settings.rb..."
    rm -f config/settings.rb
    echo "Tentando sem settings.rb..."
    ruby -e "require 'hanami'; require_relative 'config/app'; puts '✅ Boot sem settings'" || {
        echo "❌ Falha grave"
        exit 1
    }
fi
