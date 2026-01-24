require "rack"
require "json"
require_relative "lib/data_analyzer_api/services/demographic_calculator"
require_relative "lib/data_analyzer_api/services/regional_calculator"

class Sprint2Server
  def initialize

    @sample_data = [
      {
        "customer_gender" => "M",
        "customer_age" => 28,
        "customer_city" => "São Paulo",
        "customer_state" => "SP",
        "customer_income" => 7500,
        "final_value" => 1899.90,
        "product_name" => "iPhone 15",
        "customer_id" => "CLI001"
      },
      {
        "customer_gender" => "F", 
        "customer_age" => 35,
        "customer_city" => "Rio de Janeiro",
        "customer_state" => "RJ",
        "customer_income" => 6200,
        "final_value" => 1299.90,
        "product_name" => "Samsung Galaxy S24",
        "customer_id" => "CLI002"
      },
      {
        "customer_gender" => "M",
        "customer_age" => 42,
        "customer_city" => "Belo Horizonte",
        "customer_state" => "MG",
        "customer_income" => 8500,
        "final_value" => 2499.90,
        "product_name" => "Notebook Dell XPS",
        "customer_id" => "CLI003"
      },
      {
        "customer_gender" => "F",
        "customer_age" => 25,
        "customer_city" => "Porto Alegre",
        "customer_state" => "RS",
        "customer_income" => 4800,
        "final_value" => 899.90,
        "product_name" => "iPad Air",
        "customer_id" => "CLI004"
      },
      {
        "customer_gender" => "M",
        "customer_age" => 38,
        "customer_city" => "Curitiba",
        "customer_state" => "PR",
        "customer_income" => 7200,
        "final_value" => 1599.90,
        "product_name" => "Samsung Galaxy Tab",
        "customer_id" => "CLI005"
      }
    ]
    
    @demographic_calculator = DataAnalyzerApi::Services::DemographicCalculator.new(@sample_data)
    @regional_calculator = DataAnalyzerApi::Services::RegionalCalculator.new(@sample_data)
  end
  
  def call(env)
    request = Rack::Request.new(env)
    method = request.request_method
    path = request.path
    
    puts "[SPRINT2] #{method} #{path}"
    
    case "#{method} #{path}"
    when "GET /"
      json_response(200, {
        api: "Hanami Data Analyzer API",
        version: "2.0",
        status: "online",
        sprint: "2 em execução",
        endpoints: {
          sprint1: ["GET /reports/sales-summary", "GET /reports/product-analysis", "GET /reports/financial-metrics"],
          sprint2: ["GET /reports/regional-performance", "GET /reports/customer-profile"],
          core: ["GET /", "GET /health", "POST /upload"]
        }
      })
      
    when "GET /health"
      json_response(200, {
        status: "healthy",
        environment: "development",
        database: "sqlite3",
        sprint: "2 ativa",
        timestamp: Time.now.iso8601
      })
      
    when "GET /reports/sales-summary"
      json_response(200, {
        status: "success",
        sprint: "1",
        data: {
          total_sales: 8208.50,
          average_transaction: 1641.70,
          total_transactions: 5,
          period: "2024-01-01 a 2024-01-31"
        }
      })
      
    when "GET /reports/regional-performance"
      handle_regional_performance(request)
      
    when "GET /reports/customer-profile"
      handle_customer_profile(request)
      
    when "GET /reports/product-analysis"
      json_response(200, {
        status: "success",
        sprint: "1",
        data: {
          top_products: [
            { product: "iPhone 15", revenue: 1899.90, units: 1 },
            { product: "Notebook Dell XPS", revenue: 2499.90, units: 1 },
            { product: "Samsung Galaxy S24", revenue: 1299.90, units: 1 }
          ],
          total_products: 5
        }
      })
      
    when "GET /reports/financial-metrics"
      json_response(200, {
        status: "success",
        sprint: "1",
        data: {
          gross_profit: 2462.55,
          net_revenue: 8208.50,
          total_cost: 5745.95,
          profit_margin: 30.0
        }
      })
      
    when "POST /upload"
      json_response(200, {
        status: "success",
        message: "Upload simulado - Sprint 1 implementado",
        rows_processed: 1500,
        valid_rows: 1450
      })
      
    else
      json_response(404, {
        error: "Endpoint não encontrado",
        path: path,
        documentation: "Veja GET / para lista de endpoints"
      })
    end
  end
  
  private
  
  def handle_regional_performance(request)
    params = request.params
    region = params["regiao"]
    estado = params["estado"]
    
    if estado
      data = @regional_calculator.performance_by_state.select { |state, _| state == estado }
      message = "Performance do estado #{estado}"
    elsif region
      data = @regional_calculator.performance_by_state(region)
      message = "Performance da região #{region}"
    else
      data = @regional_calculator.performance_by_region
      message = "Performance por região"
    end
    
    json_response(200, {
      status: "success",
      sprint: "2",
      message: message,
      data: data,
      filters: params.to_h.compact,
      implemented: "Módulo RegionalCalculator"
    })
  end
  
  def handle_customer_profile(request)
    params = request.params
    limit = params["limit"]&.to_i || 5
    
    json_response(200, {
      status: "success",
      sprint: "2",
      message: "Perfil demográfico dos clientes",
      data: {
        gender_distribution: @demographic_calculator.gender_distribution,
        age_distribution: @demographic_calculator.age_distribution,
        top_cities: @demographic_calculator.top_cities(limit),
        state_distribution: @demographic_calculator.state_distribution,
        average_income: @demographic_calculator.average_income,
        total_customers: @sample_data.map { |c| c["customer_id"] }.uniq.size
      },
      filters: params.to_h.compact,
      implemented: "Módulo DemographicCalculator"
    })
  end
  
  def json_response(status, data)
    [
      status,
      { "Content-Type" => "application/json" },
      [JSON.pretty_generate(data)]
    ]
  end
end


if __FILE__ == $0
  require "rackup"
  puts "=" * 60
  puts "🚀 SERVIDOR SPRINT 2 INICIADO"
  puts "📡 Porta: 2300"
  puts "📊 Sprint 2 em produção!"
  puts "=" * 60
  puts ""
  puts "Endpoints disponíveis:"
  puts "  GET  /                         - Status da API"
  puts "  GET  /health                   - Health check"
  puts "  GET  /reports/sales-summary    - Resumo de vendas (Sprint 1)"
  puts "  GET  /reports/regional-performance - Performance regional (Sprint 2)"
  puts "  GET  /reports/customer-profile    - Perfil de clientes (Sprint 2)"
  puts "  GET  /reports/product-analysis - Análise de produtos (Sprint 1)"
  puts "  GET  /reports/financial-metrics - Métricas financeiras (Sprint 1)"
  puts "  POST /upload                   - Upload de arquivos (Sprint 1)"
  puts ""
  puts "Filtros disponíveis (Sprint 2):"
  puts "  /reports/regional-performance?regiao=Sudeste"
  puts "  /reports/regional-performance?estado=SP"
  puts "  /reports/customer-profile?limit=10"
  puts "=" * 60
  
  Rackup::Server.start(app: Sprint2Server.new, Port: 2300, Host: "0.0.0.0")
end
