# Hanami Data Analyzer API

API para análise de dados de vendas em CSV/XLSX com Hanami 2.3.

## Status do Projeto

### Sprint 1 (Concluída)
**✅ Implementado:**
- **POST /upload** - Upload e processamento de arquivos CSV/XLSX
- **GET /reports/sales-summary** - Resumo geral de vendas
- **GET /reports/product-analysis** - Análise de produtos
- **GET /reports/financial-metrics** - Métricas financeiras
- Integração com banco de dados

### Sprint 2 (Concluída)
**✅ Implementado:**
- **GET /reports/regional-performance** - Performance por região geográfica
- **GET /reports/customer-profile** - Perfil demográfico dos clientes
- Módulo `DemographicCalculator` - Análise demográfica
- Módulo `RegionalCalculator` - Análise regional
- Filtros dinâmicos por região e estado
- Servidor de desenvolvimento funcional

## Tecnologias Utilizadas

- **Ruby 3.4.7**
- **Hanami 2.3.2** - Framework web
- **SQLite3** - Banco de dados (desenvolvimento)
- **Puma** - Servidor web
- **RSpec** - Testes
- **Rack** - Interface web

## Instalação Rápida

### Pré-requisitos
```bash
# Ruby 3.4.7+
ruby --version

# Bundler
gem install bundler

# SQLite3 (opcional, para desenvolvimento)
sqlite3 --version

### 1. Clone o Repositório

```bash
git clone https://github.com/renatomoraesf/hanami-data-analyzer-api.git
cd hanami-data-analyzer-api
```

### 2. Instale as Dependências

```bash
bundle install
```

### 3. Configure o Ambiente

```bash
# Copie o arquivo de exemplo .env
cp .env.example .env  # Ou crie manualmente

# Conteúdo do .env:
# HANAMI_ENV=development
# DATABASE_URL=sqlite://db/data_analyzer_development.sqlite
# SESSION_SECRET=seu_secret_aqui
# LOG_LEVEL=info
```

### 4. Execute o Servidor de Desenvolvimento
```bash
# Servidor Sprint 2 (recomendado para testes)
bundle exec ruby sprint2_server.rb

# Ou para desenvolvimento Hanami completo
HANAMI_ENV=development bundle exec rackup -p 2300 config.ru
```
A API estará disponível em: http://localhost:2300

### Endpoints da API
#### Status e Health Check

```bash
GET / → Status da API
GET /health → Health check do sistema
```

#### Upload de Arquivos
```bash
POST /upload
Content-Type: multipart/form-data

Parâmetros:
- file: Arquivo CSV/XLSX para upload

Resposta (sucesso):
{
  "status": "success",
  "rows_processed": 1500,
  "valid_rows": 1450
}
```
###  Relatórios de Vendas
```bash
GET /reports/sales-summary
GET /reports/sales-summary?start_date=2024-01-01&end_date=2024-01-31

Resposta:
{
  "total_sales": 1250000.50,
  "average_transaction": 450.75,
  "total_transactions": 2775
}
```

```bash
GET /reports/product-analysis
GET /reports/product-analysis?limit=10&sort_by=revenue

Resposta:
{
  "top_products": [
    {
      "product": "iPhone 15",
      "revenue": 250000,
      "units": 500
    }
  ]
}
```

```bash
GET /reports/financial-metrics

Resposta:
{
  "gross_profit": 375000,
  "net_revenue": 1250000,
  "profit_margin": 30.0
}
```

### Análise Regional

```bash
GET /reports/regional-performance
GET /reports/regional-performance?regiao=Sudeste
GET /reports/regional-performance?estado=SP

Resposta:
{
  "Sudeste": {
    "total_sales": 850000,
    "transaction_count": 1800,
    "average_sale": 472.22
  }
}
```

### Perfil de Clientes

```bash
GET /reports/customer-profile
GET /reports/customer-profile?limit=5
GET /reports/customer-profile?estado=SP

Resposta:
{
  "gender_distribution": {
    "M": 58,
    "F": 42
  },
  "age_distribution": {
    "18-25": 22,
    "26-35": 35,
    "36-45": 25
  }
}
```

### Estrutura do Projeto

```bash
hanami-data-analyzer-api/
├── config/                    # Configurações da aplicação
│   ├── app.rb               # Configuração principal
│   ├── routes.rb            # Rotas globais
│   ├── settings.rb          # Configurações
│   └── providers/           # Providers de dependência
│
├── slices/api/              # Slice principal da API
│   ├── actions/            # Controllers/Actions
│   │   ├── home/           # Página inicial
│   │   ├── uploads/        # Upload de arquivos
│   │   └── reports/        # Endpoints de relatórios
│   │       ├── sales_summary.rb
│   │       ├── regional_performance.rb
│   │       ├── customer_profile.rb
│   │       ├── product_analysis.rb
│   │       └── financial_metrics.rb
│   ├── config/routes.rb    # Rotas do slice
│   └── slice.rb            # Configuração do slice
│
├── lib/data_analyzer_api/  # Lógica de negócio
│   ├── services/          # Serviços
│   │   ├── csv_processor.rb
│   │   ├── demographic_calculator.rb  # Sprint 2
│   │   └── regional_calculator.rb     # Sprint 2
│   ├── persistence/       # Camada de dados
│   └── validators/        # Validações
│
├── db/                    # Migrations e banco de dados
├── spec/                  # Testes
├── public/                # Arquivos públicos
├── log/                   # Logs da aplicação
│
├── sprint2_server.rb      # Servidor de desenvolvimento
├── config.ru              # Configuração Rack
├── Gemfile               # Dependências
└── README.md             # Esta documentação
```


## Módulos
### DemographicCalculator
```bash
# lib/data_analyzer_api/services/demographic_calculator.rb
calculator = DemographicCalculator.new(sales_data)
calculator.gender_distribution    # Distribuição por gênero
calculator.age_distribution       # Distribuição por faixa etária
calculator.top_cities(10)         # Top 10 cidades
calculator.average_income         # Renda média
```

### RegionalCalculator

```bash
# lib/data_analyzer_api/services/regional_calculator.rb
calculator = RegionalCalculator.new(sales_data)
calculator.performance_by_region          # Performance por região
calculator.performance_by_state("Sudeste") # Performance por estado
```

Regiões mapeadas:

<ul><li><p class="ds-markdown-paragraph"><strong><span>Norte</span></strong><span>: AC, AP, AM, PA, RO, RR, TO</span></p></li><li><p class="ds-markdown-paragraph"><strong><span>Nordeste</span></strong><span>: AL, BA, CE, MA, PB, PE, PI, RN, SE</span></p></li><li><p class="ds-markdown-paragraph"><strong><span>Centro-Oeste</span></strong><span>: DF, GO, MT, MS</span></p></li><li><p class="ds-markdown-paragraph"><strong><span>Sudeste</span></strong><span>: ES, MG, RJ, SP</span></p></li><li><p class="ds-markdown-paragraph"><strong><span>Sul</span></strong><span>: PR, RS, SC</span></p></li></ul>
🧪 Testando a API
Testes Rápidos com cURL

<br>
<div class="ds-scroll-area _1210dd7 c03cafe9"><div class="ds-scroll-area__gutters" style="position: sticky; top: 0px; left: 0px; right: 0px; height: 0px; --container-height: 321px;"><div class="ds-scroll-area__horizontal-gutter" style="left: 0px; right: 0px; display: block; top: calc(var(--container-height) - 14px); height: 10px;"><div class="ds-scroll-area__horizontal-bar" style="display: none;"></div></div><div class="ds-scroll-area__vertical-gutter" style="right: 0px; top: 8px; bottom: calc(0px - var(--container-height) + 8px); width: 10px;"><div class="ds-scroll-area__vertical-bar" style="display: none;"></div></div></div><table><thead><tr><th><span>Método</span></th><th><span>Endpoint</span></th><th><span>Descrição</span></th><th><span>Status</span></th></tr></thead><tbody><tr><td><code>GET</code></td><td><code>/reports/regional-performance</code></td><td><span>Performance por região</span></td><td><span>🚧</span></td></tr><tr><td><code>GET</code></td><td><code>/reports/customer-profile</code></td><td><span>Perfil demográfico dos clientes</span></td><td><span>🚧</span></td></tr><tr><td><code>GET</code></td><td><code>/analytics/trends</code></td><td><span>Análise de tendências temporais</span></td><td><span>🚧</span></td></tr><tr><td><code>GET</code></td><td><code>/data/search</code></td><td><span>Busca filtrada nos dados</span></td><td><span>🚧</span></td></tr><tr><td><code>GET</code></td><td><code>/reports/download?format=json</code></td><td><span>Exportação JSON de relatórios</span></td><td><span>🚧</span></td></tr><tr><td><code>GET</code></td><td><code>/reports/download?format=pdf</code></td><td><span>Exportação PDF de relatórios</span></td><td><span>🚧</span></td></tr></tbody></table></div>

### Testando a API
#### Testes Rápidos com cURL
```bash
# Status da API
curl http://localhost:2300/

# Health check
curl http://localhost:2300/health

# Relatórios da Sprint 2
curl http://localhost:2300/reports/regional-performance
curl http://localhost:2300/reports/customer-profile?limit=3

# Com filtros
curl "http://localhost:2300/reports/regional-performance?regiao=Sudeste"
curl "http://localhost:2300/reports/customer-profile?estado=SP"
```


#### Testes Automatizados
```bash
# Executar todos os testes
bundle exec rspec

# Testes específicos
bundle exec rspec spec/requests
bundle exec rspec spec/lib/data_analyzer_api/services
```


#### Formato do CSV de Entrada
```bash
id_transacao,data_venda,valor_final,subtotal,desconto_percent,canal_venda,forma_pagamento,cliente_id,nome_cliente,idade_cliente,genero_cliente,cidade_cliente,estado_cliente,renda_estimada,produto_id,nome_produto,categoria,marca,preco_unitario,quantidade,margem_lucro,regiao,status_entrega,tempo_entrega_dias,vendedor_id
TXN00000001,2024-01-15,1500.75,1650.00,10,Online,Cartão Crédito,CLI000001,João Silva,35,M,São Paulo,SP,7500,PRD001,iPhone 15,Smartphones,Apple,1500.00,1,25,Sudeste,Entregue,3,VEN001
TXN00000002,2024-01-16,890.50,890.50,0,Loja Física,PIX,CLI000002,Maria Santos,28,F,Rio de Janeiro,RJ,5500,PRD002,Samsung Galaxy S24,Smartphones,Samsung,890.00,1,20,Sudeste,Entregue,2,VEN002
```
## Troubleshooting
### Problemas Comuns
#### 1.Erro ao iniciar servidor

```bash
# Verifique se as gems estão instaladas
bundle install

# Limpe o cache do Hanami
rm -rf .hanami/ tmp/

# Verifique o arquivo .env
cat .env
```
#### 2. Erro de banco de dados
```bash
# SQLite não instalado
gem install sqlite3

# Ou altere para PostgreSQL no .env
DATABASE_URL=postgresql://localhost:5432/data_analyzer_development
```
#### 3. Porta em uso
```bash
# Libere a porta 2300
lsof -ti:2300 | xargs kill -9 2>/dev/null || true
```

#### Logs
```bash
# Ver logs em tempo real
tail -f log/development.log

# Logs de erro
grep -i error log/development.log
```

## Contribuindo
<ol start="1"><li><p class="ds-markdown-paragraph"><span>Fork o projeto</span></p></li><li><p class="ds-markdown-paragraph"><span>Crie uma branch para sua feature (</span><code>git checkout -b feature/AmazingFeature</code><span>)</span></p></li><li><p class="ds-markdown-paragraph"><span>Commit suas mudanças (</span><code>git commit -m 'Add some AmazingFeature'</code><span>)</span></p></li><li><p class="ds-markdown-paragraph"><span>Push para a branch (</span><code>git push origin feature/AmazingFeature</code><span>)</span></p></li><li><p class="ds-markdown-paragraph"><span>Abra um Pull Request</span></p></li></ol>

## Padrões de Código
<ul><li><p class="ds-markdown-paragraph"><span>Siga as convenções do Ruby Style Guide</span></p></li><li><p class="ds-markdown-paragraph"><span>Use RuboCop para linting: </span><code>bundle exec rubocop</code></p></li><li><p class="ds-markdown-paragraph"><span>Escreva testes para novas funcionalidades</span></p></li><li><p class="ds-markdown-paragraph"><span>Documente novas APIs</span></p></li></ul>

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
