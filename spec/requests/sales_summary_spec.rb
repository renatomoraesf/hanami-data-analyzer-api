# spec/requests/reports/sales_summary_spec.rb

require 'swagger_helper'

RSpec.describe '/reports/sales-summary', type: :request do
  path '/reports/sales-summary' do
    get('Retorna um resumo das vendas') do
      tags 'Relatórios'
      description 'Retorna métricas consolidadas de vendas como total de vendas, média por transação e número de transações'
      produces 'application/json'
      
      response(200, 'successful') do
        schema type: :object,
          properties: {
            total_vendas: { type: :number, example: 150000.50 },
            media_por_transacao: { type: :number, example: 250.75 },
            numero_transacoes: { type: :integer, example: 598 },
            data_inicio: { type: :string, example: '2023-01-01' },
            data_fim: { type: :string, example: '2023-12-31' }
          }
        
        run_test!
      end
      
      response(400, 'bad request') do
        schema type: :object,
          properties: {
            error: { type: :string, example: 'Nenhum dado carregado. Faça upload primeiro.' }
          }
        
        run_test!
      end
    end
  end
end