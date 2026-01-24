# lib/data_analyzer_api/persistence/repositories/sales_repo.rb
module DataAnalyzerApi
  module Persistence
    module Repositories
      class SalesRepo < ROM::Repository[:sales]
        include Import["persistence.rom"]

        commands :create, update: :by_pk, delete: :by_pk

        def all
          sales.to_a
        end

        def find_by_transaction_id(transaction_id)
          sales.where(transaction_id: transaction_id).one
        end

        def create_many(sales_data)
          sales.command(:create, result: :many).call(sales_data)
        end

        def sales_summary(start_date: nil, end_date: nil)
          query = sales
          query = query.by_date_range(start_date, end_date) if start_date && end_date
          query.summary_stats
        end

        def sales_by_channel(start_date: nil, end_date: nil)
          query = sales
          query = query.by_date_range(start_date, end_date) if start_date && end_date
          
          query
            .select(:sales_channel)
            .select_append {
              [
                function(:count, :id).as(:transaction_count),
                function(:sum, :final_value).as(:total_sales),
                function(:avg, :final_value).as(:average_sale)
              ]
            }
            .group(:sales_channel)
            .to_a
        end

        def sales_by_region(start_date: nil, end_date: nil)
          query = sales
          query = query.by_date_range(start_date, end_date) if start_date && end_date
          
          query
            .select(:region)
            .select_append {
              [
                function(:count, :id).as(:transaction_count),
                function(:sum, :final_value).as(:total_sales),
                function(:avg, :final_value).as(:average_sale)
              ]
            }
            .group(:region)
            .to_a
        end
      end
    end
  end
end

        # Análise por região
        def regional_performance(start_date: nil, end_date: nil)
          query = sales
          query = query.by_date_range(start_date, end_date) if start_date && end_date
          
          query
            .select(:region)
            .select_append {
              [
                function(:count, :id).as(:transaction_count),
                function(:sum, :final_value).as(:total_sales),
                function(:avg, :final_value).as(:average_sale),
                function(:avg, :delivery_days).as(:avg_delivery_days),
                function(:sum, :quantity).as(:total_units)
              ]
            }
            .group(:region)
            .order(Sequel.desc(:total_sales))
            .to_a
        end
        
        # Análise de produtos
        def product_analysis(start_date: nil, end_date: nil, limit: 10)
          query = sales
          query = query.by_date_range(start_date, end_date) if start_date && end_date
          
          query
            .select(:product_id, :product_name, :product_category, :product_brand)
            .select_append {
              [
                function(:count, :id).as(:transaction_count),
                function(:sum, :final_value).as(:total_sales),
                function(:sum, :quantity).as(:total_units),
                function(:avg, :final_value).as(:average_price),
                function(:avg, :profit_margin).as(:avg_profit_margin),
                function(:sum, sequel.lit('final_value * profit_margin / 100')).as(:estimated_profit)
              ]
            }
            .group(:product_id, :product_name, :product_category, :product_brand)
            .order(Sequel.desc(:total_sales))
            .limit(limit)
            .to_a
        end
        
        # Análise por categoria
        def category_analysis(start_date: nil, end_date: nil)
          query = sales
          query = query.by_date_range(start_date, end_date) if start_date && end_date
          
          query
            .select(:product_category)
            .select_append {
              [
                function(:count, :id).as(:transaction_count),
                function(:sum, :final_value).as(:total_sales),
                function(:sum, :quantity).as(:total_units),
                function(:avg, :profit_margin).as(:avg_profit_margin)
              ]
            }
            .group(:product_category)
            .order(Sequel.desc(:total_sales))
            .to_a
        end
        
        # Perfil dos clientes
        def customer_profile(start_date: nil, end_date: nil)
          query = sales
          query = query.by_date_range(start_date, end_date) if start_date && end_date
          
          # Demografia
          demographics = query
            .select(:customer_gender)
            .select_append {
              [
                function(:count, :id).as(:customer_count),
                function(:sum, :final_value).as(:total_spent),
                function(:avg, :customer_age).as(:avg_age),
                function(:avg, :customer_income).as(:avg_income)
              ]
            }
            .group(:customer_gender)
            .to_a
            
          # Por cidade
          by_city = query
            .select(:customer_city, :customer_state)
            .select_append {
              [
                function(:count, :id).as(:transaction_count),
                function(:sum, :final_value).as(:total_sales),
                function(:count, function(:distinct, :customer_id)).as(:unique_customers)
              ]
            }
            .group(:customer_city, :customer_state)
            .order(Sequel.desc(:total_sales))
            .limit(10)
            .to_a
            
          # Por faixa etária
          age_brackets = query
            .select {
              [
                sequel.case(
                  [
                    [{ customer_age: 0..18 }, '0-18'],
                    [{ customer_age: 19..25 }, '19-25'],
                    [{ customer_age: 26..35 }, '26-35'],
                    [{ customer_age: 36..50 }, '36-50'],
                    [{ customer_age: 51..100 }, '51+']
                  ],
                  'Outros'
                ).as(:age_bracket),
                function(:count, :id).as(:customer_count),
                function(:sum, :final_value).as(:total_spent)
              ]
            }
            .group(:age_bracket)
            .order(:age_bracket)
            .to_a
            
          {
            demographics: demographics,
            top_cities: by_city,
            age_distribution: age_brackets,
            total_unique_customers: query.select(function(:count, function(:distinct, :customer_id))).first[:count]
          }
        end
        
        # Métricas financeiras detalhadas
        def financial_metrics(start_date: nil, end_date: nil)
          query = sales
          query = query.by_date_range(start_date, end_date) if start_date && end_date
          
          base_metrics = query.summary_stats || {}
          
          # Métricas por canal
          channel_metrics = query
            .select(:sales_channel)
            .select_append {
              [
                function(:count, :id).as(:transaction_count),
                function(:sum, :final_value).as(:total_sales),
                function(:avg, :discount_percent).as(:avg_discount)
              ]
            }
            .group(:sales_channel)
            .to_a
            
          # Métricas por método de pagamento
          payment_metrics = query
            .select(:payment_method)
            .select_append {
              [
                function(:count, :id).as(:transaction_count),
                function(:sum, :final_value).as(:total_sales),
                function(:avg, :final_value).as(:avg_transaction_value)
              ]
            }
            .group(:payment_method)
            .to_a
            
          # Estatísticas de desconto
          discount_stats = query
            .select {
              [
                function(:avg, :discount_percent).as(:avg_discount_percent),
                function(:max, :discount_percent).as(:max_discount_percent),
                function(:sum, sequel.lit('subtotal - final_value')).as(:total_discount_value)
              ]
            }
            .first || {}
          
          # Margem de lucro
          profit_stats = query
            .select {
              [
                function(:avg, :profit_margin).as(:avg_profit_margin),
                function(:sum, sequel.lit('final_value * profit_margin / 100')).as(:estimated_total_profit)
              ]
            }
            .first || {}
          
          {
            base_metrics: base_metrics,
            by_channel: channel_metrics,
            by_payment_method: payment_metrics,
            discount_analysis: discount_stats,
            profit_analysis: profit_stats
          }
        end
        
        # Análise de tendências temporais
        def temporal_trends(start_date: nil, end_date: nil, group_by: 'day')
          query = sales
          query = query.by_date_range(start_date, end_date) if start_date && end_date
          
          case group_by
          when 'day'
            date_format = "%Y-%m-%d"
          when 'week'
            date_format = "%Y-%W"
          when 'month'
            date_format = "%Y-%m"
          when 'year'
            date_format = "%Y"
          else
            date_format = "%Y-%m-%d"
          end
          
          query
            .select {
              [
                sequel.function(:to_char, :sale_date, date_format).as(:period),
                function(:count, :id).as(:transaction_count),
                function(:sum, :final_value).as(:total_sales),
                function(:avg, :final_value).as(:average_sale),
                function(:sum, :quantity).as(:total_units)
              ]
            }
            .group(Sequel.function(:to_char, :sale_date, date_format))
            .order(:period)
            .to_a
        end
        
        # Busca com filtros
        def search(filters = {})
          query = sales
          
          # Aplicar filtros
          if filters[:start_date] && filters[:end_date]
            query = query.by_date_range(filters[:start_date], filters[:end_date])
          end
          
          if filters[:channel]
            query = query.where(sales_channel: filters[:channel])
          end
          
          if filters[:region]
            query = query.where(region: filters[:region])
          end
          
          if filters[:product_category]
            query = query.where(product_category: filters[:product_category])
          end
          
          if filters[:min_value]
            query = query.where { final_value >= filters[:min_value].to_f }
          end
          
          if filters[:max_value]
            query = query.where { final_value <= filters[:max_value].to_f }
          end
          
          # Paginação
          limit = filters[:limit] || 50
          offset = filters[:offset] || 0
          
          query
            .limit(limit)
            .offset(offset)
            .order(Sequel.desc(:sale_date))
            .to_a
        end

        # Cálculos financeiros específicos
        def calculate_financial_metrics(start_date: nil, end_date: nil)
          query = sales
          query = query.by_date_range(start_date, end_date) if start_date && end_date
          
          # Obter dados brutos
          raw_data = query.to_a
          
          return empty_financial_metrics if raw_data.empty?
          
          # Calcular métricas
          total_sales = raw_data.sum { |s| s.final_value.to_f }
          total_cost = raw_data.sum { |s| calculate_cost(s) }
          total_discount = raw_data.sum { |s| s.subtotal.to_f - s.final_value.to_f }
          
          {
            receita_liquida: total_sales.round(2),
            receita_bruta: raw_data.sum { |s| s.subtotal.to_f }.round(2),
            lucro_bruto: (total_sales - total_cost).round(2),
            custo_total: total_cost.round(2),
            desconto_total: total_discount.round(2),
            margem_bruta: total_sales > 0 ? ((total_sales - total_cost) / total_sales * 100).round(2) : 0,
            ticket_medio: (total_sales / raw_data.size).round(2)
          }
        end
        
        private
        
        def calculate_cost(sale)
          # Estimativa de custo baseada no preço e margem
          # Custo = Valor Final / (1 + Margem/100)
          margin = sale.profit_margin.to_f
          final_value = sale.final_value.to_f
          
          if margin > 0
            (final_value / (1 + margin/100)).round(2)
          else
            (final_value * 0.7).round(2) # Estimativa padrão de 30% de margem
          end
        end
        
        def empty_financial_metrics
          {
            receita_liquida: 0,
            receita_bruta: 0,
            lucro_bruto: 0,
            custo_total: 0,
            desconto_total: 0,
            margem_bruta: 0,
            ticket_medio: 0
          }
        end
