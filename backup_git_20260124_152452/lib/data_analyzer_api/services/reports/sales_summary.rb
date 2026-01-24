module HanamiDataAnalyzer
  module Services
    module Reports
      class SalesSummary
        def initialize(data: [])
          @data = data
        end

        def call
          return empty_response if @data.empty?

          {
            summary: basic_summary,
            by_channel: sales_by_channel,
            by_period: sales_by_period,
            metadata: {
              total_records: @data.size,
              generated_at: Time.now.iso8601
            }
          }
        end

        private

        def empty_response
          {
            summary: {
              total_sales: 0,
              average_sale: 0,
              total_transactions: 0,
              total_discount: 0
            },
            by_channel: {},
            by_period: {},
            metadata: {
              total_records: 0,
              generated_at: Time.now.iso8601
            }
          }
        end

        def basic_summary
          total_sales = @data.sum { |item| item[:valor_final].to_f }
          total_subtotal = @data.sum { |item| item[:subtotal].to_f }
          total_discount = total_subtotal - total_sales

          {
            total_sales: total_sales.round(2),
            average_sale: (total_sales / @data.size).round(2),
            total_transactions: @data.size,
            total_discount: total_discount.round(2),
            discount_percentage: ((total_discount / total_subtotal * 100) if total_subtotal > 0).round(2)
          }
        end

        def sales_by_channel
          channels = @data.group_by { |item| item[:canal_venda] }
          
          channels.transform_values do |items|
            total = items.sum { |item| item[:valor_final].to_f }
            count = items.size
            
            {
              total_sales: total.round(2),
              transaction_count: count,
              percentage: ((count.to_f / @data.size) * 100).round(2)
            }
          end
        end

        def sales_by_period
          period_data = @data.group_by do |item|
            date = Date.parse(item[:data_venda]) rescue nil
            date&.strftime("%Y-%m") if date
          end.compact
          
          period_data.transform_values do |items|
            total = items.sum { |item| item[:valor_final].to_f }
            {
              total_sales: total.round(2),
              transaction_count: items.size,
              average_sale: (total / items.size).round(2)
            }
          end.sort_by { |period, _| period }.to_h
        end
      end
    end
  end
end