# Hanami Data Analyzer API

API para análise de dados de vendas com processamento de arquivos CSV/XLSX e geração de relatórios analíticos com exportação em JSON e PDF.

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

### Sprint 2 (Concluída)
- **GET /reports/regional-performance** - Performance por região
- **GET /reports/customer-profile** - Perfil de clientes
- **GET /analytics/trends** - Análise de tendências
- Exportação JSON/PDF
- Documentação Swagger/OpenAPI
- Endpoints de análise de clientes e regiões
- Deploy com Docker
- Filtros dinâmicos nos relatórios

## Instalação Rápida

### Pré-requisitos
- **Ruby 3.4.7+**
- **SQLite 3**
- **Bundler 2.4+**
- **Docker (opcional, para containerização)**

### 1. Clone o Repositório
```bash
git clone https://github.com/renatomoraesf/hanami-data-analyzer-api
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

### Ou use Docker
```bash
# Build e inicie o container
docker-compose up

# A API estará disponível em http://localhost:2300
```

## Documentação da API

### Acesso ao Swagger UI
Após iniciar o servidor, acesse:
```
http://localhost:2300/swagger-ui.html
```

A documentação interativa inclui:
- Descrição detalhada de todos os endpoints
- Exemplos de request e response
- Parâmetros e schemas documentados
- Interface para testar os endpoints

### Endpoints Disponíveis

#### Upload e Processamento
| Método | Endpoint | Descrição | Status |
|--------|----------|-----------|--------|
| `POST` | `/api/uploads` | Upload de arquivo CSV/XLSX | ✅ |

#### Relatórios e Análises
| Método | Endpoint | Descrição | Status |
|--------|----------|-----------|--------|
| `GET` | `/api/reports/download?format=json` | Download de relatório em JSON | ✅ |
| `GET` | `/api/reports/download?format=pdf` | Download de relatório em PDF | ✅ |

## Como Usar

### 1. Testar Status da API
```bash
curl http://localhost:2300/swagger-ui.html
```

### 2. Download de Relatório JSON
```bash
curl "http://localhost:2300/api/reports/download?format=json" | jq .
```

**Exemplo de Resposta:**
```json
{
  "sales_summary": {
    "total_vendas": 7541.5,
    "numero_transacoes": 5,
    "media_por_transacao": 1508.3
  },
  "financial_metrics": {
    "receita_liquida": 7541.5,
    "custo_total": 4524.9,
    "lucro_bruto": 3016.6
  },
  "products": [
    {
      "nome": "PRD003",
      "quantidade": 1,
      "total": 3200.0
    }
  ]
}
```

### 3. Download de Relatório PDF
```bash
curl -o report.pdf "http://localhost:2300/api/reports/download?format=pdf"
```

O PDF inclui:
- Métricas Financeiras (receita, lucro, custos)
- Análise de Produtos (ranking de vendas)
- Tabelas formatadas com Prawn
- Timestamp de geração

### 4. Upload de Arquivo CSV (Planejado)
```bash
curl -X POST -F "file=@vendas.csv" http://localhost:2300/api/uploads
```

## Estrutura do Projeto

```
hanami-data-analyzer-api/
├── app/                    # Application base
│   ├── action.rb          # Base action class
│   └── actions/           # App-level actions (futuro)
│
├── config/                # Configurações
│   ├── app.rb            # Config principal + CORS + Static files
│   ├── routes.rb         # Rotas globais
│   ├── inflections.rb    # Inflector customizado
│   └── providers/        # Dependency injection
│       ├── services.rb   # Registro de serviços
│       └── logger.rb     # Configuração de logs
│
├── slices/api/           # API Slice
│   ├── actions/         # Endpoints
│   │   ├── home/       # Status e health check
│   │   ├── uploads/    # Upload de arquivos
│   │   └── reports/    # Geração de relatórios
│   ├── config/routes.rb # Rotas do slice
│   ├── action.rb        # Base action do slice
│   └── slice.rb         # Configuração do slice
│
├── lib/data_analyzer_api/  # Business logic
│   └── services/           # Serviços
│       ├── mock_data.rb         # Dados de exemplo
│       ├── report_generator.rb  # Geração de relatórios
│       └── pdf_exporter.rb      # Export para PDF com Prawn
│
├── public/               # Assets públicos
│   ├── swagger-ui.html  # Interface Swagger UI
│   └── openapi.json     # Spec OpenAPI 3.0
│
├── docker-compose.yml   # Orquestração Docker
├── Dockerfile           # Imagem Docker
└── Gemfile              # Dependências Ruby
```

## Tecnologias Utilizadas

### Core
- **[Hanami 2.3.2](https://hanamirb.org/)** - Framework web moderno
- **[Ruby 3.2.2](https://www.ruby-lang.org/)** - Linguagem de programação
- **[Puma](https://puma.io/)** - Servidor web de alto desempenho
- **[Dry-rb](https://dry-rb.org/)** - Dependency injection e utilitários

### Funcionalidades
- **[Prawn](https://prawnpdf.org/)** - Geração de PDFs
- **[Prawn-Table](https://github.com/prawnpdf/prawn-table)** - Tabelas em PDFs
- **[Rack-CORS](https://github.com/cyu/rack-cors)** - Suporte a CORS

### Desenvolvimento
- **[Docker](https://www.docker.com/)** - Containerização
- **[Swagger UI](https://swagger.io/tools/swagger-ui/)** - Documentação interativa
- **[Better Errors](https://github.com/BetterErrors/better_errors)** - Debug melhorado

## Docker

### Comandos Úteis

```bash
# Build da imagem
docker-compose build

# Iniciar container
docker-compose up

# Iniciar em background
docker-compose up -d

# Ver logs
docker-compose logs -f

# Parar container
docker-compose down

# Rebuild completo
docker-compose down
docker-compose build --no-cache
docker-compose up
```

### Configuração

O projeto está configurado com:
- ✅ Volumes para desenvolvimento (hot reload)
- ✅ Persistência de dados (SQLite)
- ✅ Porta 2300 exposta
- ✅ Ambiente de desenvolvimento

## Métricas e Análises

### Relatórios Disponíveis

#### 1. Resumo de Vendas
- Total de vendas
- Número de transações
- Média por transação

#### 2. Métricas Financeiras
- Receita líquida
- Custo total estimado
- Lucro bruto
- Margens de rentabilidade

#### 3. Análise de Produtos
- Ranking de produtos por vendas
- Quantidade vendida por produto
- Total de receita por produto

## Desenvolvimento

### Executar Testes
```bash
# Todos os testes
bundle exec rspec

# Com detalhes
bundle exec rspec --format documentation

# Cobertura
bundle exec rspec --format html --out coverage.html
```

### Adicionar Novo Endpoint

1. **Criar Action:**
```ruby
# slices/api/actions/reports/novo_relatorio.rb
module Api
  module Actions
    module Reports
      class NovoRelatorio < Hanami::Action
        def handle(request, response)
          response.status = 200
          response.headers["Content-Type"] = "application/json"
          response.body = { data: "exemplo" }.to_json
        end
      end
    end
  end
end
```

2. **Adicionar Rota:**
```ruby
# slices/api/config/routes.rb
get "/reports/novo", to: "reports.novo_relatorio"
```

3. **Documentar no OpenAPI:**
Edite `public/openapi.json` e adicione o endpoint.

## Troubleshooting

### Problema: Porta 2300 em uso
```bash
# Encontrar processo
lsof -ti:2300

# Matar processo
lsof -ti:2300 | xargs kill -9
```

### Problema: Erro no Docker
```bash
# Limpar containers antigos
docker-compose down --remove-orphans

# Limpar volumes
docker-compose down -v

# Rebuild completo
docker-compose build --no-cache
```

### Problema: Gems não instaladas
```bash
# Reinstalar
bundle install

# Ou com docker
docker-compose build --no-cache
```

## Logs

```bash
# Ver logs da aplicação
tail -f log/development.log

# Logs do Docker
docker-compose logs -f

# Filtrar erros
grep -i error log/development.log
```

##  Contribuindo

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/NovaFeature`)
3. Commit suas mudanças (`git commit -m 'Add: Nova feature'`)
4. Push para a branch (`git push origin feature/NovaFeature`)
5. Abra um Pull Request

### Padrões de Commit
```
feat: Nova funcionalidade
fix: Correção de bug
docs: Documentação
style: Formatação
refactor: Refatoração
test: Testes
chore: Manutenção
```

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
