#!/bin/bash

echo "🔧 Corrigindo autenticação PostgreSQL..."

# 1. Usar senha no comando
echo "Testando com senha..."
PGPASSWORD=hanami123 psql -h localhost -U hanami -d data_analyzer_api_dev -c "SELECT '✅ Conectado com senha' as status;" 2>/dev/null && {
    echo "✅ Funciona com senha"
    echo "Use: PGPASSWORD=hanami123 psql -h localhost -U hanami -d data_analyzer_api_dev -c \"\\dt\""
    exit 0
}

# 2. Configurar pg_hba.conf
echo "Configurando pg_hba.conf para trust..."
sudo cp /etc/postgresql/*/main/pg_hba.conf /etc/postgresql/*/main/pg_hba.conf.backup

sudo tee /etc/postgresql/*/main/pg_hba.conf > /dev/null << 'CONFIG'
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             postgres                                peer
local   all             all                                     trust
host    all             all             127.0.0.1/32            trust
host    all             all             ::1/128                 trust
CONFIG

# 3. Reiniciar
echo "Reiniciando PostgreSQL..."
sudo service postgresql restart
sleep 2

# 4. Testar
echo "Testando nova configuração..."
psql -U hanami -d data_analyzer_api_dev -c "SELECT '✅ Autenticação corrigida' as status;" 2>/dev/null && {
    echo "🎉 Funcionou!"
    psql -U hanami -d data_analyzer_api_dev -c "\dt"
} || {
    echo "❌ Ainda falhou, tentando outro método..."
    
    # 5. Criar usuário postgres com mesmo nome do sistema
    sudo -u postgres createuser --superuser $USER 2>/dev/null
    psql -d data_analyzer_api_dev -c "\dt" 2>/dev/null || echo "Falha final"
}
