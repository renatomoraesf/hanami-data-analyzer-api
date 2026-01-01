#!/bin/bash

cd /workspaces/hanami-data-analyzer-api

echo "=== VERIFICAÇÃO DE ESTRUTURA ==="

echo "1. Arquivos de configuração:"
[ -f "config.ru" ] && echo "✅ config.ru" || echo "❌ config.ru"
[ -f "config/app.rb" ] && echo "✅ config/app.rb" || echo "❌ config/app.rb"
[ -f "config/routes.rb" ] && echo "✅ config/routes.rb" || echo "❌ config/routes.rb"

echo -e "\n2. Conteúdo config.ru:"
cat config.ru

echo -e "\n3. Conteúdo config/app.rb:"
cat config/app.rb

echo -e "\n4. Conteúdo config/routes.rb:"
cat config/routes.rb

echo -e "\n5. Actions:"
find apps -name "*.rb" 2>/dev/null | head -5

echo -e "\n6. Teste de boot simples:"
ruby -e "
begin
  require 'hanami'
  require_relative 'config/app'
  puts '✅ Hanami boot OK'
  puts 'App class: #{DataAnalyzerApi::App}'
rescue => e
  puts '❌ Erro: #{e.message}'
  puts 'Backtrace:'
  puts e.backtrace.first(3)
end
"
