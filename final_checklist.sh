#!/bin/bash

echo "📋 CHECKLIST FINAL"

cd /workspaces/hanami-data-analyzer-api

echo "1. Commits locais:"
git log --oneline -5 2>/dev/null || echo "   Nenhum commit local"

echo -e "\n2. Remote configurado:"
git remote -v 2>/dev/null || echo "   ❌ Nenhum remote"

echo -e "\n3. Backup local:"
cd /workspaces
BACKUP_FILE="hanami-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
tar -czf "$BACKUP_FILE" hanami-data-analyzer-api/ 2>/dev/null
echo "   ✅ Backup criado: $BACKUP_FILE"
ls -lh "$BACKUP_FILE"

echo -e "\n🎯 AÇÕES NECESSÁRIAS:"
echo "A. Se tem remote: git push origin main"
echo "B. Se não tem: Baixe o backup acima para seu computador"
echo "C. Anote: Seu trabalho está em /workspaces/hanami-data-analyzer-api"
