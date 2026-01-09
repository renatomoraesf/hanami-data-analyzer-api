#!/bin/bash
echo "🚀 PREPARANDO COMMITS DO PROJETO"
echo "================================"

# Verificar se estamos no branch main
current_branch=$(git branch --show-current)
echo "Branch atual: $current_branch"

if [[ "$current_branch" != "main" ]]; then
  read -p "⚠️  Não está no branch main. Continuar? (s/N): " resp
  if [[ ! "$resp" =~ ^[Ss]$ ]]; then
    echo "❌ Abortando"
    exit 1
  fi
fi

echo ""
echo "1. 📋 STATUS ATUAL DO GIT:"
echo "--------------------------"
git status --short

echo ""
read -p "Continuar com os commits? (s/N): " resp
if [[ ! "$resp" =~ ^[Ss]$ ]]; then
  echo "❌ Abortado pelo usuário"
  exit 0
fi

echo ""
echo "2. 🔍 ANALISANDO MUDANÇAS:"
echo "-------------------------"

# Contar tipos de mudanças
deleted=$(git status --porcelain | grep -c "^ D\|^D")
modified=$(git status --porcelain | grep -c "^ M\|^M")
new=$(git status --porcelain | grep -c "^??\|^A")

echo "Arquivos deletados: $deleted"
echo "Arquivos modificados: $modified"
echo "Novos arquivos: $new"

echo ""
echo "3. 💾 COMMIT 1: LIMPEZA DO PROJETO"
echo "---------------------------------"

if [ $deleted -gt 0 ]; then
  echo "Adicionando arquivos deletados..."
  git add -u
  git commit -m "chore: limpeza do projeto

- Remove arquivos de debug e teste desnecessários
- Limpa logs e cache antigos (hanami.log, server.log)
- Remove estruturas duplicadas (apps/, app/)
- Deleta scripts temporários de diagnóstico
- Remove backups de configuração"
  echo "✅ Commit 1 criado"
else
  echo "⚠️  Nenhum arquivo deletado para commit"
fi

echo ""
echo "4. 🛠️  COMMIT 2: CORREÇÕES DA SPRINT 1"
echo "-------------------------------------"

if [ $modified -gt 0 ] || [ $new -gt 0 ]; then
  echo "Adicionando correções e implementações..."
  
  # Adicionar arquivos importantes
  important_files=()
  
  # Configuração
  [ -f "config/app.rb" ] && important_files+=("config/app.rb")
  [ -f "config/settings.rb" ] && important_files+=("config/settings.rb")
  [ -f "config/routes.rb" ] && important_files+=("config/routes.rb")
  [ -d "config/providers" ] && important_files+=("config/providers")
  
  # Slices
  [ -f "slices/api/action.rb" ] && important_files+=("slices/api/action.rb")
  [ -f "slices/api/slice.rb" ] && important_files+=("slices/api/slice.rb")
  [ -d "slices/api/actions" ] && important_files+=("slices/api/actions")
  
  # Lib
  [ -d "lib/data_analyzer_api" ] && important_files+=("lib/data_analyzer_api")
  
  # DB
  [ -d "db/migrate" ] && important_files+=("db/migrate")
  
  if [ ${#important_files[@]} -gt 0 ]; then
    echo "Arquivos importantes encontrados:"
    printf '  - %s\n' "${important_files[@]}"
    
    git add "${important_files[@]}"
    
    git commit -m "feat: implementa correções e melhorias da Sprint 1

- Corrige configuração do Hanami e sistema de settings
- Implementa logging básico para monitoramento
- Atualiza processador de CSV com validações robustas
- Adiciona repositórios e relações para persistência em PostgreSQL
- Implementa endpoints completos de relatórios:
  * POST /upload - Upload de arquivos CSV/XLSX
  * GET /reports/sales-summary - Resumo geral de vendas
  * GET /reports/product-analysis - Análise de produtos
  * GET /reports/financial-metrics - Métricas financeiras
- Adiciona migrations para estrutura do banco de dados
- Implementa serviços de cálculo financeiro"
    echo "✅ Commit 2 criado"
  else
    echo "⚠️  Nenhum arquivo importante modificado"
  fi
fi

echo ""
echo "5. 📚 COMMIT 3: DOCUMENTAÇÃO"
echo "---------------------------"

if [ -f "README.md" ]; then
  echo "Adicionando documentação..."
  git add README.md
  
  # Adicionar outros arquivos de docs se existirem
  docs_files=("API_DOCUMENTATION.md" "DOCUMENTATION.md" "docs/")
  for doc in "${docs_files[@]}"; do
    if [ -f "$doc" ] || [ -d "$doc" ]; then
      git add "$doc"
      echo "  ✅ Adicionado: $doc"
    fi
  done
  
  git commit -m "docs: atualiza documentação do projeto

- Adiciona README.md completo com:
  * Instalação e configuração passo a passo
  * Documentação de todos os endpoints da API
  * Estrutura do projeto e organização
  * Guia de desenvolvimento e contribuição
  * Troubleshooting e FAQ
- Documenta status atual da Sprint 1
- Inclui exemplos práticos de uso da API
- Adiciona plano para Sprint 2"
  echo "✅ Commit 3 criado"
else
  echo "⚠️  README.md não encontrado"
fi

echo ""
echo "6. 📦 COMMIT 4: ARQUIVOS RESTANTES"
echo "---------------------------------"

# Verificar se ainda há arquivos não commitados
remaining=$(git status --porcelain | wc -l)

if [ $remaining -gt 0 ]; then
  echo "Ainda há $remaining arquivos não commitados"
  git status --short
  
  read -p "Adicionar arquivos restantes? (s/N): " resp
  if [[ "$resp" =~ ^[Ss]$ ]]; then
    git add .
    git commit -m "chore: organiza arquivos restantes do projeto

- Adiciona scripts úteis de verificação e teste
- Organiza estrutura final do projeto
- Inclui arquivos de configuração e ambiente
- Prepara base para início da Sprint 2"
    echo "✅ Commit 4 criado"
  else
    echo "⚠️  Arquivos restantes não commitados"
  fi
else
  echo "✅ Todos os arquivos já foram commitados"
fi

echo ""
echo "7. 📊 RESUMO DOS COMMITS:"
echo "------------------------"
git log --oneline -5

echo ""
echo "8. 🚀 PREPARAR PARA PUSH:"
echo "-----------------------"

# Verificar se há commits para push
ahead=$(git rev-list --count origin/main..HEAD 2>/dev/null || echo "0")

if [ "$ahead" -gt 0 ]; then
  echo "Commits ahead of origin/main: $ahead"
  
  read -p "Fazer push para o repositório remoto? (s/N): " resp
  if [[ "$resp" =~ ^[Ss]$ ]]; then
    echo "Executando git push..."
    git push origin "$current_branch"
    echo "✅ Push realizado com sucesso!"
  else
    echo "⚠️  Push não realizado. Use 'git push' quando quiser."
  fi
else
  echo "ℹ️  Nenhum commit novo para push"
fi

echo ""
echo "🎉 PROCESSO DE COMMIT CONCLUÍDO!"
echo "================================"
echo ""
echo "📋 Próximos passos recomendados:"
echo "1. Verificar se todos os commits foram criados: git log --oneline -10"
echo "2. Testar a API localmente: bundle exec hanami server"
echo "3. Executar verificação da Sprint 1: ./verify_sprint1.sh"
echo "4. Planejar início da Sprint 2"
