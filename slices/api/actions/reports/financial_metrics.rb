# slices/api/actions/reports/financial_metrics.rb
module Api
  module Actions
    module Reports
      class FinancialMetrics < Api::Action
        include Deps["persistence.repositories.sales_repo"]
        
        def handle(request, response)
          start_date = parse_date(request.params[:start_date])
          end_date = parse_date(request.params[:end_date])
          
          metrics = sales_repo.financial_metrics(
            start_date: start_date,
            end_date: end_date
          )
          
          # Extrair dados
          base = metrics[:base_metrics] || {}
          by_channel = metrics[:by_channel] || []
          by_payment = metrics[:by_payment_method] || []
          discount = metrics[:discount_analysis] || {}
          profit = metrics[:profit_analysis] || {}
          
          # Calcular métricas derivadas
          total_sales = base[:total_sales].to_f
          total_transactions = base[:total_transactions].to_i
          total_discount = discount[:total_discount_value].to_f
          total_subtotal = base[:total_subtotal].to_f
          
          avg_transaction_value = total_transactions > 0 ? (total_sales / total_transactions).round(2) : 0
          discount_rate = total_subtotal > 0 ? (total_discount / total_subtotal * 100).round(2) : 0
          profit_margin = total_sales > 0 ? (profit[:estimated_total_profit].to_f / total_sales * 100).round(2) : 0
          
          # Formatar canais
          formatted_channels = by_channel.map do |channel|
            {
              channel: channel.sales_channel,
              transaction_count: channel.transaction_count,
              total_sales: channel.total_sales.to_f.round(2),
              avg_discount: channel.avg_discount.to_f.round(1),
              channel_share: calculate_percentage(channel.total_sales.to_f, total_sales)
            }
          end
          
          # Formatar métodos de pagamento
          formatted_payments = by_payment.map do |payment|
            {
              method: payment.payment_method,
              transaction_count: payment.transaction_count,
              total_sales: payment.total_sales.to_f.round(2),
              avg_transaction_value: payment.avg_transaction_value.to_f.round(2),
              method_share: calculate_percentage(payment.total_sales.to_f, total_sales)
            }
          end
          
          json_response({
            report: "Financial Metrics",
            period: format_period(start_date, end_date),
            key_metrics: {
              sales_performance: {
                total_sales: total_sales.round(2),
                total_transactions: total_transactions,
                average_transaction_value: avg_transaction_value,
                total_subtotal: total_subtotal.round(2)
              },
              discount_analysis: {
                total_discount_value: total_discount.round(2),
                average_discount_percent: discount[:avg_discount_percent]&.to_f&.round(1) || 0,
                max_discount_percent: discount[:max_discount_percent]&.to_i || 0,
                overall_discount_rate: discount_rate
              },
              profitability: {
                estimated_total_profit: profit[:estimated_total_profit]&.to_f&.round(2) || 0,
                average_profit_margin: profit[:avg_profit_margin]&.to_f&.round(1) || 0,
                overall_profit_margin: profit_margin
              }
            },
            channel_analysis: {
              channels: formatted_channels,
              top_channel: formatted_channels.max_by { |c| c[:total_sales] }&.dig(:channel) || "N/A"
            },
            payment_analysis: {
              methods: formatted_payments,
              most_used_method: formatted_payments.max_by { |p| p[:transaction_count] }&.dig(:method) || "N/A",
              highest_value_method: formatted_payments.max_by { |p| p[:avg_transaction_value] }&.dig(:method) || "N/A"
            },
            financial_health_indicators: {
              conversion_rate: "N/A", # Seria calculado se tivéssemos dados de visitantes
              customer_acquisition_cost: "N/A",
              customer_lifetime_value: "N/A",
              return_on_ad_spend: "N/A"
            },
            recommendations: generate_financial_recommendations(
              total_sales, discount_rate, profit_margin, formatted_channels, formatted_payments
            ),
            metadata: {
              generated_at: Time.now.iso8601,
              filters_applied: {
                start_date: start_date&.to_s,
                end_date: end_date&.to_s
              }
            }
          })
        end
        
        private
        
        def parse_date(date_str)
          return nil if date_str.to_s.empty?
          Date.parse(date_str) rescue nil
        end
        
        def format_period(start_date, end_date)
          if start_date && end_date
            "#{start_date.to_s} to #{end_date.to_s}"
          else
            "All available data"
          end
        end
        
        def calculate_percentage(value, total)
          total > 0 ? ((value / total) * 100).round(2) : 0
        end
        
        def generate_financial_recommendations(sales, discount_rate, profit_margin, channels, payments)
          recommendations = []
          
          # Recomendações baseadas em desconto
          if discount_rate > 15
            recommendations << "Consider reducing overall discount rate (currently #{discount_rate}%) to improve margins"
          elsif discount_rate < 5
            recommendations << "Consider strategic discounts to boost sales volume"
          end
          
          # Recomendações baseadas em margem de lucro
          if profit_margin < 20
            recommendations << "Profit margin (#{profit_margin}%) is below optimal. Review pricing or costs"
          end
          
          # Recomendações baseadas em canais
          if channels.any?
            top_channel = channels.max_by { |c| c[:total_sales] }
            worst_channel = channels.min_by { |c| c[:total_sales] }
            
            if top_channel && worst_channel
              recommendations << "Focus marketing efforts on #{top_channel[:channel]} channel (highest sales)"
              recommendations << "Investigate poor performance in #{worst_channel[:channel]} channel"
            end
          end
          
          # Recomendações baseadas em métodos de pagamento
          if payments.any?
            high_value_method = payments.max_by { |p| p[:avg_transaction_value] }
            if high_value_method && high_value_method[:avg_transaction_value] > (sales / 100) # 1% do total
              recommendations << "Promote #{high_value_method[:method]} payment method (higher average transaction value)"
            end
          end
          
          recommendations.empty? ? ["All financial metrics are within optimal ranges"] : recommendations
        end
        
        def json_response(data, status: 200)
          self.status = status
          self.body = data.to_json
          headers["Content-Type"] = "application/json"
        end
      end
    end
  end
end
