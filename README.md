 **Hanami Data Analyzer API**
API robusta para análise de dados de vendas em CSV/XLSX com Hanami 2.3.

**Status do Projeto**
*Sprint 1 (Concluída)*
Implementado:

POST /upload - Upload e processamento de CSV/XLSX

GET /reports/sales-summary - Resumo geral de vendas

GET /reports/product-analysis - Análise de produtos

GET /reports/financial-metrics - Métricas financeiras

Módulo de validação e processamento de dados

Integração com PostgreSQL

**Em Andamento:**

Configuração avançada de logging

Suporte completo a XLSX

Documentação detalhada

*Sprint 2 (Planejada)*
GET /reports/regional-performance - Performance por região

GET /reports/customer-profile - Perfil de clientes

GET /analytics/trends - Análise de tendências

Exportação JSON/PDF

Documentação Swagger

Deploy com Docker

*Instalação Rápida*
Pré-requisitos:
Ruby 3.4.7+

PostgreSQL 14+

Bundler 2.4+

**1. Clone o Repositório**

git clone <seu-repositorio>
cd hanami-data-analyzer-api

**2. Instale as Dependências**

bundle install

**3. Configure o Banco de Dados**

createdb data_analyzer_development


bundle exec hanami db create
bundle exec hanami db migrate

**4. Inicie o Servidor**

bundle exec hanami server
# A API estará disponível em http://localhost:2300

Configuração do Ambiente
Variáveis de Ambiente
Crie um arquivo .env na raiz do projeto:

HANAMI_ENV=development
DATABASE_URL=postgres://localhost:5432/data_analyzer_development
DATABASE_USER=postgres
DATABASE_PASSWORD=
SESSION_SECRET=development_secret_change_in_production
LOG_LEVEL=info
MAX_UPLOAD_SIZE=52428800  # 50MB em bytes

Configuração do PostgreSQL

# Se necessário, crie o usuário PostgreSQL
sudo -u postgres createuser --createdb --login --pwprompt seu_usuario

# Ou use o usuário padrão
createdb data_analyzer_development

Endpoints da API
Endpoints Principais (Sprint 1)
Método	Endpoint	Descrição	Status
GET	/	Status da API e lista de endpoints	✅
GET	/health	Health check do sistema	✅
POST	/upload	Upload de arquivos CSV/XLSX	✅
GET	/reports/sales-summary	Resumo geral de vendas	✅
GET	/reports/product-analysis	Análise de produtos	✅
GET	/reports/financial-metrics	Métricas financeiras	✅
📊 Endpoints Futuros (Sprint 2)
Método	Endpoint	Descrição	Status
GET	/reports/regional-performance	Performance por região	🚧
GET	/reports/customer-profile	Perfil demográfico dos clientes	🚧
GET	/analytics/trends	Análise de tendências temporais	🚧
GET	/data/search	Busca filtrada nos dados	🚧
GET	/reports/download?format=json	Exportação JSON de relatórios	🚧
GET	/reports/download?format=pdf	Exportação PDF de relatórios	🚧

**Como Usar a API**
1. Testar a API

# Verifique se a API está rodando
curl http://localhost:2300/

# Health check
curl http://localhost:2300/health

2. Upload de Arquivo CSV

# Envie um arquivo CSV para processamento
curl -X POST -F "file=@seus_dados.csv" http://localhost:2300/upload

# Exemplo de resposta de sucesso:
# {
#   "status": "success",
#   "message": "Arquivo processado com sucesso",
#   "data": {
#     "filename": "vendas.csv",
#     "rows_processed": 1000,
#     "valid_rows": 950,
#     "sample_data": [...]
#   }
# }

3. Obter Relatórios

# Resumo de vendas
curl http://localhost:2300/reports/sales-summary

# Análise de produtos (com limite de 10 resultados)
curl "http://localhost:2300/reports/product-analysis?limit=10"

# Métricas financeiras com filtro de data
curl "http://localhost:2300/reports/financial-metrics?start_date=2024-01-01&end_date=2024-01-31"

4. Parâmetros de Filtro Disponíveis
Parâmetro	Tipo	Descrição	Exemplo
start_date	String	Data inicial (YYYY-MM-DD)	?start_date=2024-01-01
end_date	String	Data final (YYYY-MM-DD)	?end_date=2024-01-31
limit	Integer	Limite de resultados	?limit=20
format	String	Formato de exportação	?format=json

**Estrutura do Projeto**

hanami-data-analyzer-api/
├── config/                  # Configurações
│   ├── app.rb              # Configuração principal do Hanami
│   ├── routes.rb           # Rotas globais da aplicação
│   ├── settings.rb         # Configurações da aplicação
│   └── providers/          # Providers de dependência
│       ├── persistence.rb  # Configuração do banco de dados
│       └── logger.rb       # Configuração de logging
│
├── slices/api/             # Slice principal da API
│   ├── actions/            # Actions/Controllers
│   │   ├── home/           # Actions da home
│   │   │   ├── show.rb     # Página inicial
│   │   │   └── health.rb   # Health check
│   │   ├── uploads/        # Upload de arquivos
│   │   │   └── create.rb   # Processamento de upload
│   │   ├── reports/        # Endpoints de relatórios
│   │   │   ├── sales_summary.rb
│   │   │   ├── product_analysis.rb
│   │   │   ├── financial_metrics.rb
│   │   │   ├── regional_performance.rb
│   │   │   └── customer_profile.rb
│   │   ├── analytics/      # Análises avançadas
│   │   │   └── trends.rb
│   │   └── data/           # Busca de dados
│   │       └── search.rb
│   ├── config/routes.rb    # Rotas do slice
│   └── slice.rb            # Configuração do slice
│
├── lib/data_analyzer_api/  # Código da aplicação
│   ├── services/           # Serviços de negócio
│   │   ├── csv_processor.rb # Processamento de CSV
│   │   ├── file_processor.rb # Processamento de arquivos
│   │   └── data_store.rb   # Armazenamento em memória
│   │
│   ├── persistence/        # Camada de persistência
│   │   ├── relations/      # Relations ROM.rb
│   │   │   ├── sales.rb
│   │   │   └── file_processings.rb
│   │   └── repositories/   # Repositórios
│   │       ├── sales_repo.rb
│   │       └── file_processing_repo.rb
│   │
│   └── validators/         # Validações
│       └── csv_validator.rb
│
├── db/                     # Migrations e seeds
│   └── migrate/           # Migrations do banco
│       ├── 001_create_sales.rb
│       └── 002_create_file_processings.rb
│
├── spec/                   # Testes automatizados
├── public/                 # Arquivos públicos
├── tmp/                    # Arquivos temporários
├── log/                    # Logs da aplicação
│
├── Gemfile                 # Dependências do Ruby
├── Gemfile.lock            # Versões travadas
├── README.md               # Esta documentação
├── .env                    # Variáveis de ambiente
└── config.ru               # Configuração Rack

**Estrutura de Dados**
Tabela sales (Vendas)
A API processa e armazena os seguintes dados:

Campo	Tipo	Descrição	Obrigatório
transaction_id	String	ID único da transação	✅
sale_date	Date	Data da venda	✅
final_value	Decimal	Valor final (com desconto)	✅
subtotal	Decimal	Valor bruto	✅
discount_percent	Integer	Percentual de desconto (0-30)	✅
sales_channel	String	Canal de venda	✅
payment_method	String	Método de pagamento	✅
customer_id	String	ID do cliente	✅
customer_name	String	Nome do cliente	✅
customer_age	Integer	Idade do cliente (18-70)	✅
customer_gender	String	Gênero (M/F)	✅
customer_city	String	Cidade do cliente	✅
customer_state	String	Estado (sigla)	✅
customer_income	Decimal	Renda estimada	✅
product_id	String	ID do produto	✅
product_name	String	Nome do produto	✅
product_category	String	Categoria do produto	✅
product_brand	String	Marca do produto	✅
unit_price	Decimal	Preço unitário	✅
quantity	Integer	Quantidade vendida	✅
profit_margin	Integer	Margem de lucro (15-60%)	✅
region	String	Região geográfica	✅
delivery_status	String	Status da entrega	✅
delivery_days	Integer	Dias para entrega (1-15)	✅
seller_id	String	ID do vendedor	✅


Formato do CSV de Entrada

id_transacao,data_venda,valor_final,subtotal,desconto_percent,canal_venda,forma_pagamento,cliente_id,nome_cliente,idade_cliente,genero_cliente,cidade_cliente,estado_cliente,renda_estimada,produto_id,nome_produto,categoria,marca,preco_unitario,quantidade,margem_lucro,regiao,status_entrega,tempo_entrega_dias,vendedor_id
TXN00000001,2024-01-15,1500.75,1650.00,10,Online,Cartão Crédito,CLI000001,João Silva,35,M,São Paulo,SP,7500,PRD001,iPhone 15,Smartphones,Apple,1500.00,1,25,Sudeste,Entregue,3,VEN001
TXN00000002,2024-01-16,890.50,890.50,0,Loja Física,PIX,CLI000002,Maria Santos,28,F,Rio de Janeiro,RJ,5500,PRD002,Samsung Galaxy S24,Smartphones,Samsung,890.00,1,20,Sudeste,Entregue,2,VEN002

Desenvolvimento
Iniciar Ambiente de Desenvolvimento

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

# slices/api/actions/reports/novo_endpoint.rb
module Api
  module Actions
    module Reports
      class NovoEndpoint < Api::Action
        include Deps["persistence.repositories.sales_repo"]
        
        def handle(request, response)
          # Extrair parâmetros
          start_date = parse_date(request.params[:start_date])
          
          # Obter dados
          data = sales_repo.novo_metodo(start_date: start_date)
          
          # Formatar resposta
          response.body = {
            status: "success",
            data: data,
            metadata: {
              generated_at: Time.now.iso8601
            }
          }.to_json
        end
        
        private
        
        def parse_date(date_str)
          return nil if date_str.to_s.empty?
          Date.parse(date_str) rescue nil
        end
      end
    end
  end
end

**Métricas e Análises Disponíveis**
1. Vendas
Total de vendas: Soma de todos os valores finais

Média por transação: Valor médio de cada venda

Número de transações: Quantidade total de vendas

Distribuição por canal: Vendas por Online/Loja Física/Marketplace

Desconto médio: Percentual médio de desconto aplicado

2. Produtos
Top produtos por vendas: Produtos mais vendidos em valor

Análise por categoria: Desempenho por categoria de produto

Margem de lucro por produto: Rentabilidade individual

Unidades vendidas: Quantidade total por produto

3. Financeiro
Receita líquida: Total de vendas após descontos

Lucro bruto: Receita menos custos estimados

Custo total: Estimativa de custos totais

Análise de desconto: Impacto dos descontos nas vendas

Métricas de rentabilidade: Margens e ROI

4. Clientes (Sprint 2)
Demografia: Distribuição por gênero e idade

Distribuição geográfica: Clientes por cidade/estado

Renda média: Perfil socioeconômico

Frequência de compra: Padrões de compra

5. Regiões (Sprint 2)
Performance por região: Vendas por região geográfica

Tempo médio de entrega: Eficiência logística

Market share regional: Participação por região

Satisfação do cliente: Baseado em métricas de entrega

*Testes*
Executar Testes

# Todos os testes
bundle exec rspec

# Testes específicos
bundle exec rspec spec/lib/data_analyzer_api/services
bundle exec rspec spec/requests

# Com coverage
bundle exec rspec --format documentation

*Tipos de Testes*
Testes de Unidade: Serviços e modelos (spec/lib/)

Testes de Integração: Endpoints da API (spec/requests/)

Testes de Banco: Migrations e queries (spec/persistence/)

*Troubleshooting*
Problemas Comuns
1. Erro ao iniciar servidor

# Verifique se o PostgreSQL está rodando
sudo service postgresql status
# ou
pg_isready

# Verifique as migrations
bundle exec hanami db version

# Limpe o cache
rm -rf .hanami/ tmp/

2. Erro no upload de arquivo

# Verifique o formato do arquivo
file seus_dados.csv

# Verifique as colunas obrigatórias
head -1 seus_dados.csv

# Verifique o tamanho (max 100MB)
ls -lh seus_dados.csv

3. Erro de conexão com banco

# Teste a conexão manualmente
psql -d data_analyzer_development

# Verifique as credenciais
cat .env | grep DATABASE

# Verifique se o banco existe
psql -l | grep data_analyzer_development

4. Erro "Slice 'api' is already registered"

# Limpe o cache do Hanami
rm -rf .hanami/ tmp/

# Reinicie o servidor
bundle exec hanami server

Logs

# Visualizar logs da aplicação
tail -f log/development.log

# Logs do servidor Hanami
tail -f hanami.log

# Logs específicos de erro
grep -i error log/development.log

# Monitorar logs em tempo real
tail -f log/development.log | grep -E "(ERROR|WARN|upload)"

**Contribuindo**
Fork o projeto

Crie uma branch para sua feature (git checkout -b feature/AmazingFeature)

Commit suas mudanças (git commit -m 'Add some AmazingFeature')

Push para a branch (git push origin feature/AmazingFeature)

Abra um Pull Request

Padrões de Código
Siga as convenções do Ruby Style Guide

Use RuboCop para linting (bundle exec rubocop)

Escreva testes para novas funcionalidades

Documente novas APIs no README

Mantenha o código limpo e organizado

Guia de Commits

feat:      Nova funcionalidade
fix:       Correção de bug
docs:      Documentação
style:     Formatação, pontuação, etc
refactor:  Refatoração de código
test:      Adição ou correção de testes
chore:     Tarefas de build, configuração, etc

📄 **Licença**
Este projeto está licenciado sob a MIT License - veja o arquivo LICENSE para detalhes.