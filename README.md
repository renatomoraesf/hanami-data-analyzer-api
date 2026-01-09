📊 Hanami Data Analyzer API
API robusta para análise de dados de vendas em CSV/XLSX com Hanami 2.3.

🚀 Status do Projeto
📋 Sprint 1 (Concluída ~85%)
✅ Implementado:

POST /upload - Upload e processamento de CSV/XLSX

GET /reports/sales-summary - Resumo geral de vendas

GET /reports/product-analysis - Análise de produtos

GET /reports/financial-metrics - Métricas financeiras

Módulo de validação e processamento de dados

Integração com PostgreSQL

🔄 Em Andamento:

Configuração avançada de logging

Suporte completo a XLSX

Documentação detalhada

🎯 Sprint 2 (Planejada)
GET /reports/regional-performance

GET /reports/customer-profile

GET /analytics/trends

Exportação JSON/PDF

Documentação Swagger

Deploy com Docker

📦 Instalação Rápida
Pré-requisitos
Ruby 3.4.7+

PostgreSQL 14+

Bundler 2.4+

1. Clone o Repositório
bash
git clone <https://github.com/renatomoraesf/hanami-data-analyzer-api/>
cd hanami-data-analyzer-api
2. Instale as Dependências
bash
bundle install
3. Configure o Banco de Dados
bash
# Crie o banco de dados
createdb data_analyzer_development

# Execute as migrations
bundle exec hanami db create
bundle exec hanami db migrate
4. Inicie o Servidor
bash
bundle exec hanami server
# A API estará disponível em http://localhost:2300
🛠️ Configuração do Ambiente
Variáveis de Ambiente
Crie um arquivo .env na raiz do projeto:

bash
# .env
HANAMI_ENV=development
DATABASE_URL=postgres://localhost:5432/data_analyzer_development
DATABASE_USER=postgres
DATABASE_PASSWORD=
SESSION_SECRET=development_secret_change_in_production
LOG_LEVEL=info
Configuração do PostgreSQL
bash
# Se necessário, crie o usuário PostgreSQL
sudo -u postgres createuser --createdb --login --pwprompt seu_usuario

# Ou use o usuário padrão
createdb data_analyzer_development
📡 Endpoints da API
🔍 Endpoints Principais (Sprint 1)
Método	Endpoint	Descrição
GET	/	Status da API e lista de endpoints
GET	/health	Health check do sistema
POST	/upload	Upload de arquivos CSV/XLSX
GET	/reports/sales-summary	Resumo geral de vendas
GET	/reports/product-analysis	Análise de produtos
GET	/reports/financial-metrics	Métricas financeiras
📊 Endpoints Futuros (Sprint 2)
GET /reports/regional-performance - Performance por região

GET /reports/customer-profile - Perfil demográfico dos clientes

GET /analytics/trends - Análise de tendências temporais

GET /data/search - Busca filtrada nos dados

GET /reports/download?format=json/pdf - Exportação de relatórios

🧪 Como Usar a API
1. Testar a API
bash
# Verifique se a API está rodando
curl http://localhost:2300/

# Health check
curl http://localhost:2300/health
2. Upload de Arquivo CSV
bash
# Envie um arquivo CSV para processamento
curl -X POST -F "file=@seus_dados.csv" http://localhost:2300/upload
3. Obter Relatórios
bash
# Resumo de vendas
curl http://localhost:2300/reports/sales-summary

# Análise de produtos (com limite)
curl "http://localhost:2300/reports/product-analysis?limit=10"

# Métricas financeiras com filtro de data
curl "http://localhost:2300/reports/financial-metrics?start_date=2024-01-01&end_date=2024-01-31"
📁 Estrutura do Projeto
text
hanami-data-analyzer-api/
├── apps/                    # Aplicações (estrutura legada)
├── slices/api/              # Slice principal da API
│   ├── actions/             # Actions/controllers
│   │   ├── uploads/         # Upload de arquivos
│   │   ├── reports/         # Endpoints de relatórios
│   │   └── analytics/       # Análises avançadas
│   ├── config/routes.rb     # Rotas do slice
│   └── slice.rb             # Configuração do slice
├── lib/data_analyzer_api/   # Código da aplicação
│   ├── services/            # Serviços de negócio
│   │   ├── csv_processor.rb # Processamento de CSV
│   │   └── file_processor.rb# Processamento de arquivos
│   ├── persistence/         # Camada de persistência
│   │   ├── relations/       # Relations ROM.rb
│   │   └── repositories/    # Repositórios
│   └── validators/          # Validações
├── config/                  # Configurações
│   ├── app.rb              # Configuração principal
│   ├── routes.rb           # Rotas globais
│   ├── settings.rb         # Configurações da app
│   └── providers/          # Providers de dependência
├── db/                     # Migrations e seeds
│   └── migrate/           # Migrations do banco
├── spec/                   # Testes
├── public/                 # Arquivos públicos
└── tmp/                    # Arquivos temporários

🗄️ Estrutura de Dados
Tabela sales (Vendas)
A API processa e armazena os seguintes dados:

Campo	Tipo	Descrição
transaction_id	String	ID único da transação
sale_date	Date	Data da venda
final_value	Decimal	Valor final (com desconto)
subtotal	Decimal	Valor bruto
discount_percent	Integer	Percentual de desconto
sales_channel	String	Canal de venda
payment_method	String	Método de pagamento
customer_*	Vários	Dados do cliente
product_*	Vários	Dados do produto
region	String	Região geográfica
delivery_status	String	Status da entrega
delivery_days	Integer	Dias para entrega
seller_id	String	ID do vendedor
Formato do CSV de Entrada
csv
id_transacao,data_venda,valor_final,subtotal,desconto_percent,canal_venda,forma_pagamento,cliente_id,nome_cliente,idade_cliente,genero_cliente,cidade_cliente,estado_cliente,renda_estimada,produto_id,nome_produto,categoria,marca,preco_unitario,quantidade,margem_lucro,regiao,status_entrega,tempo_entrega_dias,vendedor_id
TXN00000001,2024-01-15,1500.75,1650.00,10,Online,Cartão Crédito,CLI000001,João Silva,35,M,São Paulo,SP,7500,PRD001,iPhone 15,Smartphones,Apple,1500.00,1,25,Sudeste,Entregue,3,VEN001
🔧 Desenvolvimento
Iniciar Ambiente de Desenvolvimento
bash
# Instale as dependências
bundle install

# Configure o banco
createdb data_analyzer_development
bundle exec hanami db migrate

# Inicie o servidor com recarregamento automático
bundle exec hanami server

# Execute os testes
bundle exec rspec
Adicionar Novos Endpoints
Crie a action em slices/api/actions/

Adicione a rota em config/routes.rb

Implemente a lógica de negócio em lib/data_analyzer_api/services/

Exemplo: Nova Action
ruby
# slices/api/actions/reports/novo_endpoint.rb
module Api
  module Actions
    module Reports
      class NovoEndpoint < Api::Action
        include Deps["persistence.repositories.sales_repo"]
        
        def handle(request, response)
          # Sua lógica aqui
          data = sales_repo.novo_metodo
          response.body = data.to_json
        end
      end
    end
  end
end
🧪 Testes
Executar Testes
bash
# Todos os testes
bundle exec rspec

# Testes específicos
bundle exec rspec spec/lib/data_analyzer_api/services
bundle exec rspec spec/requests
Tipos de Testes
Testes de Unidade: Serviços e modelos

Testes de Integração: Endpoints da API

Testes de Banco: Migrations e queries

🐳 Docker (Futuro)
Build da Imagem
bash
docker build -t hanami-data-analyzer .
Executar com Docker Compose
bash
docker-compose up
Acessar a API
text
http://localhost:8000
📈 Métricas e Análises Disponíveis
1. Vendas
Total de vendas

Média por transação

Número de transações

Distribuição por canal

2. Produtos
Top produtos por vendas

Análise por categoria

Margem de lucro por produto

Unidades vendidas

3. Financeiro
Receita líquida

Lucro bruto

Custo total

Análise de desconto

Métricas de rentabilidade

4. Clientes (Sprint 2)
Demografia (gênero, idade)

Distribuição geográfica

Renda média

Frequência de compra

5. Regiões (Sprint 2)
Performance por região

Tempo médio de entrega

Market share regional

🔍 Troubleshooting
Problemas Comuns
1. Erro ao iniciar servidor
bash
# Verifique se o PostgreSQL está rodando
sudo service postgresql status

# Verifique as migrations
bundle exec hanami db version
2. Erro no upload de arquivo
Verifique se o arquivo é CSV ou XLSX

Confirme se as colunas obrigatórias existem

Verifique o tamanho do arquivo (max 100MB)

3. Erro de conexão com banco
bash
# Teste a conexão
psql -d data_analyzer_development

# Verifique as credenciais no .env
Logs
bash
# Visualizar logs da aplicação
tail -f log/development.log

# Logs do servidor
tail -f hanami.log
🤝 Contribuindo
Fork o projeto

Crie uma branch para sua feature (git checkout -b feature/AmazingFeature)

Commit suas mudanças (git commit -m 'Add some AmazingFeature')

Push para a branch (git push origin feature/AmazingFeature)

Abra um Pull Request

Padrões de Código
Siga as convenções do Ruby

Use RuboCop para linting

Escreva testes para novas funcionalidades

Documente novas APIs

📄 Licença
Este projeto está licenciado sob a MIT License - veja o arquivo LICENSE para detalhes.