# Hanami Data Analyzer API

API para análise de dados de vendas em CSV/XLSX com Hanami 2.3.

## Status do Projeto

### Sprint 1 (Concluída)
**✅ Implementado:**
- **POST /upload** - Upload e processamento de CSV/XLSX
- **GET /reports/sales-summary** - Resumo geral de vendas
- **GET /reports/product-analysis** - Análise de produtos
- **GET /reports/financial-metrics** - Métricas financeiras
- Módulo de validação e processamento de dados
- Integração com PostgreSQL
- Configuração avançada de logging
- Suporte completo a XLSX
- Documentação detalhada

### Sprint 2 (Planejada)
- **GET /reports/regional-performance** - Performance por região
- **GET /reports/customer-profile** - Perfil de clientes
- **GET /analytics/trends** - Análise de tendências
- Exportação JSON/PDF
- Documentação Swagger
- Deploy com Docker

## Instalação Rápida

### Pré-requisitos
- **Ruby 3.4.7+**
- **PostgreSQL 14+**
- **Bundler 2.4+**

### 1. Clone o Repositório
```bash
git clone <https://github.com/renatomoraesf/hanami-data-analyzer-api>

cd hanami-data-analyzer-api
```

### 2. Instale as Dependências

```bash
bundle install
```

### 3. Configure o Banco de Dados

```bash
# Crie o banco de dados
createdb data_analyzer_development

# Execute as migrations
bundle exec hanami db create
bundle exec hanami db migrate
```

### 4. Inicie o Servidor
```bash
bundle exec hanami server
# A API estará disponível em http://localhost:2300
```

### Configuração do Ambiente
#### Variáveis de Ambiente
Crie um arquivo <code>.env</code> na raiz do projeto:
```bash
HANAMI_ENV=development
DATABASE_URL=postgres://localhost:5432/data_analyzer_development
DATABASE_USER=postgres
DATABASE_PASSWORD=
SESSION_SECRET=development_secret_change_in_production
LOG_LEVEL=info
MAX_UPLOAD_SIZE=52428800  # 50MB em bytes
```

#### Configuração do PostgreSQL
```bash
# Se necessário, crie o usuário PostgreSQL
sudo -u postgres createuser --createdb --login --pwprompt seu_usuario

# Ou use o usuário padrão
createdb data_analyzer_development
```
###  Endpoints da API
###  Endpoints Principais (Sprint 1)
<br>
<div class="ds-scroll-area _1210dd7 c03cafe9"><div class="ds-scroll-area__gutters" style="position: sticky; top: 0px; left: 0px; right: 0px; height: 0px; --container-height: 321px;"><div class="ds-scroll-area__horizontal-gutter" style="left: 0px; right: 0px; display: block; top: calc(var(--container-height) - 14px); height: 10px;"><div class="ds-scroll-area__horizontal-bar" style="display: none;"></div></div><div class="ds-scroll-area__vertical-gutter" style="right: 0px; top: 8px; bottom: calc(0px - var(--container-height) + 8px); width: 10px;"><div class="ds-scroll-area__vertical-bar" style="display: none;"></div></div></div><table><thead><tr><th><span>Método</span></th><th><span>Endpoint</span></th><th><span>Descrição</span></th><th><span>Status</span></th></tr></thead><tbody><tr><td><code>GET</code></td><td><code>/</code></td><td><span>Status da API e lista de endpoints</span></td><td><span>✅</span></td></tr><tr><td><code>GET</code></td><td><code>/health</code></td><td><span>Health check do sistema</span></td><td><span>✅</span></td></tr><tr><td><code>POST</code></td><td><code>/upload</code></td><td><span>Upload de arquivos CSV/XLSX</span></td><td><span>✅</span></td></tr><tr><td><code>GET</code></td><td><code>/reports/sales-summary</code></td><td><span>Resumo geral de vendas</span></td><td><span>✅</span></td></tr><tr><td><code>GET</code></td><td><code>/reports/product-analysis</code></td><td><span>Análise de produtos</span></td><td><span>✅</span></td></tr><tr><td><code>GET</code></td><td><code>/reports/financial-metrics</code></td><td><span>Métricas financeiras</span></td><td><span>✅</span></td></tr></tbody></table></div>

### Endpoints Futuros (Sprint 2)
<br>
<div class="ds-scroll-area _1210dd7 c03cafe9"><div class="ds-scroll-area__gutters" style="position: sticky; top: 0px; left: 0px; right: 0px; height: 0px; --container-height: 321px;"><div class="ds-scroll-area__horizontal-gutter" style="left: 0px; right: 0px; display: block; top: calc(var(--container-height) - 14px); height: 10px;"><div class="ds-scroll-area__horizontal-bar" style="display: none;"></div></div><div class="ds-scroll-area__vertical-gutter" style="right: 0px; top: 8px; bottom: calc(0px - var(--container-height) + 8px); width: 10px;"><div class="ds-scroll-area__vertical-bar" style="display: none;"></div></div></div><table><thead><tr><th><span>Método</span></th><th><span>Endpoint</span></th><th><span>Descrição</span></th><th><span>Status</span></th></tr></thead><tbody><tr><td><code>GET</code></td><td><code>/reports/regional-performance</code></td><td><span>Performance por região</span></td><td><span>🚧</span></td></tr><tr><td><code>GET</code></td><td><code>/reports/customer-profile</code></td><td><span>Perfil demográfico dos clientes</span></td><td><span>🚧</span></td></tr><tr><td><code>GET</code></td><td><code>/analytics/trends</code></td><td><span>Análise de tendências temporais</span></td><td><span>🚧</span></td></tr><tr><td><code>GET</code></td><td><code>/data/search</code></td><td><span>Busca filtrada nos dados</span></td><td><span>🚧</span></td></tr><tr><td><code>GET</code></td><td><code>/reports/download?format=json</code></td><td><span>Exportação JSON de relatórios</span></td><td><span>🚧</span></td></tr><tr><td><code>GET</code></td><td><code>/reports/download?format=pdf</code></td><td><span>Exportação PDF de relatórios</span></td><td><span>🚧</span></td></tr></tbody></table></div>

### Como Usar a API
#### 1. Testar a API
```bash
# Verifique se a API está rodando
curl http://localhost:2300/

# Health check
curl http://localhost:2300/health
```
#### 2. Upload de Arquivo CSV
```bash
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
```
#### 3. Obter Relatórios
```bash
# Resumo de vendas
curl http://localhost:2300/reports/sales-summary

# Análise de produtos (com limite de 10 resultados)
curl "http://localhost:2300/reports/product-analysis?limit=10"

# Métricas financeiras com filtro de data
curl "http://localhost:2300/reports/financial-metrics?start_date=2024-01-01&end_date=2024-01-31"
```
#### 4. Parâmetros de Filtro Disponíveis
<br>
<div class="ds-scroll-area _1210dd7 c03cafe9"><div class="ds-scroll-area__gutters" style="position: sticky; top: 0px; left: 0px; right: 0px; height: 0px; --container-height: 230px;"><div class="ds-scroll-area__horizontal-gutter" style="left: 0px; right: 0px; display: block; top: calc(var(--container-height) - 14px); height: 10px;"><div class="ds-scroll-area__horizontal-bar" style="display: none;"></div></div><div class="ds-scroll-area__vertical-gutter" style="right: 0px; top: 8px; bottom: calc(0px - var(--container-height) + 8px); width: 10px;"><div class="ds-scroll-area__vertical-bar" style="display: none;"></div></div></div><table><thead><tr><th><span>Parâmetro</span></th><th><span>Tipo</span></th><th><span>Descrição</span></th><th><span>Exemplo</span></th></tr></thead><tbody><tr><td><code>start_date</code></td><td><span>String</span></td><td><span>Data inicial (YYYY-MM-DD)</span></td><td><code>?start_date=2024-01-01</code></td></tr><tr><td><code>end_date</code></td><td><span>String</span></td><td><span>Data final (YYYY-MM-DD)</span></td><td><code>?end_date=2024-01-31</code></td></tr><tr><td><code>limit</code></td><td><span>Integer</span></td><td><span>Limite de resultados</span></td><td><code>?limit=20</code></td></tr><tr><td><code>format</code></td><td><span>String</span></td><td><span>Formato de exportação</span></td><td><code>?format=json</code></td></tr></tbody></table></div>

Estrutura do Projeto
```bash
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
```
### Estrutura de Dados
Tabela <code>sales</code> (Vendas)
<br>
A API processa e armazena os seguintes dados:
<br>
<div class="ds-scroll-area _1210dd7 c03cafe9"><div class="ds-scroll-area__gutters" style="position: sticky; top: 0px; left: 0px; right: 0px; height: 0px; --container-height: 1194px;"><div class="ds-scroll-area__horizontal-gutter" style="left: 0px; right: 0px; display: block; top: calc(var(--container-height) - 14px); height: 10px;"><div class="ds-scroll-area__horizontal-bar" style="display: none;"></div></div><div class="ds-scroll-area__vertical-gutter" style="right: 0px; top: 8px; bottom: calc(0px - var(--container-height) + 8px); width: 10px;"><div class="ds-scroll-area__vertical-bar" style="display: none;"></div></div></div><table><thead><tr><th><span>Campo</span></th><th><span>Tipo</span></th><th><span>Descrição</span></th><th><span>Obrigatório</span></th></tr></thead><tbody><tr><td><code>transaction_id</code></td><td><span>String</span></td><td><span>ID único da transação</span></td><td><span>✅</span></td></tr><tr><td><code>sale_date</code></td><td><span>Date</span></td><td><span>Data da venda</span></td><td><span>✅</span></td></tr><tr><td><code>final_value</code></td><td><span>Decimal</span></td><td><span>Valor final (com desconto)</span></td><td><span>✅</span></td></tr><tr><td><code>subtotal</code></td><td><span>Decimal</span></td><td><span>Valor bruto</span></td><td><span>✅</span></td></tr><tr><td><code>discount_percent</code></td><td><span>Integer</span></td><td><span>Percentual de desconto (0-30)</span></td><td><span>✅</span></td></tr><tr><td><code>sales_channel</code></td><td><span>String</span></td><td><span>Canal de venda</span></td><td><span>✅</span></td></tr><tr><td><code>payment_method</code></td><td><span>String</span></td><td><span>Método de pagamento</span></td><td><span>✅</span></td></tr><tr><td><code>customer_id</code></td><td><span>String</span></td><td><span>ID do cliente</span></td><td><span>✅</span></td></tr><tr><td><code>customer_name</code></td><td><span>String</span></td><td><span>Nome do cliente</span></td><td><span>✅</span></td></tr><tr><td><code>customer_age</code></td><td><span>Integer</span></td><td><span>Idade do cliente (18-70)</span></td><td><span>✅</span></td></tr><tr><td><code>customer_gender</code></td><td><span>String</span></td><td><span>Gênero (M/F)</span></td><td><span>✅</span></td></tr><tr><td><code>customer_city</code></td><td><span>String</span></td><td><span>Cidade do cliente</span></td><td><span>✅</span></td></tr><tr><td><code>customer_state</code></td><td><span>String</span></td><td><span>Estado (sigla)</span></td><td><span>✅</span></td></tr><tr><td><code>customer_income</code></td><td><span>Decimal</span></td><td><span>Renda estimada</span></td><td><span>✅</span></td></tr><tr><td><code>product_id</code></td><td><span>String</span></td><td><span>ID do produto</span></td><td><span>✅</span></td></tr><tr><td><code>product_name</code></td><td><span>String</span></td><td><span>Nome do produto</span></td><td><span>✅</span></td></tr><tr><td><code>product_category</code></td><td><span>String</span></td><td><span>Categoria do produto</span></td><td><span>✅</span></td></tr><tr><td><code>product_brand</code></td><td><span>String</span></td><td><span>Marca do produto</span></td><td><span>✅</span></td></tr><tr><td><code>unit_price</code></td><td><span>Decimal</span></td><td><span>Preço unitário</span></td><td><span>✅</span></td></tr><tr><td><code>quantity</code></td><td><span>Integer</span></td><td><span>Quantidade vendida</span></td><td><span>✅</span></td></tr><tr><td><code>profit_margin</code></td><td><span>Integer</span></td><td><span>Margem de lucro (15-60%)</span></td><td><span>✅</span></td></tr><tr><td><code>region</code></td><td><span>String</span></td><td><span>Região geográfica</span></td><td><span>✅</span></td></tr><tr><td><code>delivery_status</code></td><td><span>String</span></td><td><span>Status da entrega</span></td><td><span>✅</span></td></tr><tr><td><code>delivery_days</code></td><td><span>Integer</span></td><td><span>Dias para entrega (1-15)</span></td><td><span>✅</span></td></tr><tr><td><code>seller_id</code></td><td><span>String</span></td><td><span>ID do vendedor</span></td><td><span>✅</span></td></tr></tbody></table></div>

### Formato do CSV de Entrada
```bash
id_transacao,data_venda,valor_final,subtotal,desconto_percent,canal_venda,forma_pagamento,cliente_id,nome_cliente,idade_cliente,genero_cliente,cidade_cliente,estado_cliente,renda_estimada,produto_id,nome_produto,categoria,marca,preco_unitario,quantidade,margem_lucro,regiao,status_entrega,tempo_entrega_dias,vendedor_id
TXN00000001,2024-01-15,1500.75,1650.00,10,Online,Cartão Crédito,CLI000001,João Silva,35,M,São Paulo,SP,7500,PRD001,iPhone 15,Smartphones,Apple,1500.00,1,25,Sudeste,Entregue,3,VEN001
TXN00000002,2024-01-16,890.50,890.50,0,Loja Física,PIX,CLI000002,Maria Santos,28,F,Rio de Janeiro,RJ,5500,PRD002,Samsung Galaxy S24,Smartphones,Samsung,890.00,1,20,Sudeste,Entregue,2,VEN002
```

### Desenvolvimento
#### Iniciar Ambiente de Desenvolvimento
```bash
#Instale as dependências
bundle install

# Configure o banco
createdb data_analyzer_development
bundle exec hanami db migrate

# Inicie o servidor com recarregamento automático
bundle exec hanami server

# Execute os testes
bundle exec rspec
```

### Adicionar Novos Endpoints
Crie a action em <code>slices/api/actions/</code>

Adicione a rota em <code>config/routes.rb</code>

Implemente a lógica de negócio em <code>lib/data_analyzer_api/services/</code>

### Exemplo: Nova Action
```bash
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
```
### Métricas e Análises Disponíveis
### 1.  Vendas
**Total de vendas**: Soma de todos os valores finais

**Média por transação**: Valor médio de cada venda

**Número de transações**: Quantidade total de vendas

**Distribuição por canal**: Vendas por Online/Loja Física/Marketplace

**Desconto médio**: Percentual médio de desconto aplicado

### 2. Produtos
**Top produtos por vendas**: Produtos mais vendidos em valor

**Análise por categoria**: Desempenho por categoria de produto

**Margem de lucro por produto**: Rentabilidade individual

**Unidades vendidas**: Quantidade total por produto

### 3. Financeiro
**Receita líquida**: Total de vendas após descontos

**Lucro bruto**: Receita menos custos estimados

**Custo total**: Estimativa de custos totais

**Análise de desconto**: Impacto dos descontos nas vendas

**Métricas de rentabilidade**: Margens e ROI

### 4. Clientes (Sprint 2)
**Demografia**: Distribuição por gênero e idade

**Distribuição geográfica**: Clientes por cidade/estado

**Renda média**: Perfil socioeconômico

**Frequência de compra**: Padrões de compra

### 5. Regiões (Sprint 2)
**Performance por região**: Vendas por região geográfica

**Tempo médio de entrega**: Eficiência logística

**Market share regional**: Participação por região

**Satisfação do cliente**: Baseado em métricas de entrega

### Testes
**Executar Testes**
```bash
# Todos os testes
bundle exec rspec

# Testes específicos
bundle exec rspec spec/lib/data_analyzer_api/services
bundle exec rspec spec/requests

# Com coverage
bundle exec rspec --format documentation
```
### Tipos de Testes
**Testes de Unidade**: Serviços e modelos (<code>spec/lib/</code>)

**Testes de Integração**: Endpoints da API (<code>spec/requests/</code>)

**Testes de Banco**: Migrations e queries (<code>spec/persistence/</code>)

### Troubleshooting
#### Problemas Comuns
#### 1. Erro ao iniciar servidor
```bash
# Verifique se o PostgreSQL está rodando
sudo service postgresql status
# ou
pg_isready

# Verifique as migrations
bundle exec hanami db version

# Limpe o cache
rm -rf .hanami/ tmp/
```
#### 2. Erro no upload de arquivo
```bash
# Verifique o formato do arquivo
file seus_dados.csv

# Verifique as colunas obrigatórias
head -1 seus_dados.csv

# Verifique o tamanho (max 100MB)
ls -lh seus_dados.csv
```
#### 3. Erro de conexão com banco
```bash
# Teste a conexão manualmente
psql -d data_analyzer_development

# Verifique as credenciais
cat .env | grep DATABASE

# Verifique se o banco existe
psql -l | grep data_analyzer_development
```
#### 4. Erro "Slice 'api' is already registered"
```bash
# Limpe o cache do Hanami
rm -rf .hanami/ tmp/

# Reinicie o servidor
bundle exec hanami server
```
#### Logs
```bash
# Visualizar logs da aplicação
tail -f log/development.log

# Logs do servidor Hanami
tail -f hanami.log

# Logs específicos de erro
grep -i error log/development.log

# Monitorar logs em tempo real
tail -f log/development.log | grep -E "(ERROR|WARN|upload)"
```
## Contribuindo
<ol start="1"><li><p class="ds-markdown-paragraph"><span>Fork o projeto</span></p></li><li><p class="ds-markdown-paragraph"><span>Crie uma branch para sua feature (</span><code>git checkout -b feature/AmazingFeature</code><span>)</span></p></li><li><p class="ds-markdown-paragraph"><span>Commit suas mudanças (</span><code>git commit -m 'Add some AmazingFeature'</code><span>)</span></p></li><li><p class="ds-markdown-paragraph"><span>Push para a branch (</span><code>git push origin feature/AmazingFeature</code><span>)</span></p></li><li><p class="ds-markdown-paragraph"><span>Abra um Pull Request</span></p></li></ol>

## Padrões de Código
<ul><li><p class="ds-markdown-paragraph"><span>Siga as convenções do Ruby Style Guide</span></p></li><li><p class="ds-markdown-paragraph"><span>Use RuboCop para linting (</span><code>bundle exec rubocop</code><span>)</span></p></li><li><p class="ds-markdown-paragraph"><span>Escreva testes para novas funcionalidades</span></p></li><li><p class="ds-markdown-paragraph"><span>Documente novas APIs no README</span></p></li><li><p class="ds-markdown-paragraph"><span>Mantenha o código limpo e organizado</span></p></li></ul>

##  Guia de Commits
```bash
feat:      Nova funcionalidade
fix:       Correção de bug
docs:      Documentação
style:     Formatação, pontuação, etc
refactor:  Refatoração de código
test:      Adição ou correção de testes
chore:     Tarefas de build, configuração, etc
```
##  Licença
<p class="ds-markdown-paragraph"><span>Este projeto está licenciado sob a MIT License - veja o arquivo </span><a href="https://LICENSE" target="_blank" rel="noreferrer"><span>LICENSE</span></a><span> para detalhes.</span></p>
