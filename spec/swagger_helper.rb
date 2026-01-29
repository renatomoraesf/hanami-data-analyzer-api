# spec/swagger_helper.rb

require 'rspec/core'
require 'rswag/specs'

RSpec.configure do |config|
  config.swagger_root = Hanami.app.root.join('swagger').to_s
  config.swagger_format = :yaml
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API Hanami - Análise de Dados',
        version: 'v1',
        description: 'API para análise de dados de vendas com relatórios exportáveis'
      },
      servers: [
        {
          url: 'http://localhost:2300',
          description: 'Servidor de desenvolvimento'
        }
      ]
    }
  }
end