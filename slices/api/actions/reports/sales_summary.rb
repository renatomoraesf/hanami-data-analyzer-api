# slices/api/actions/reports/sales_summary.rb
module API
  module Actions
    module Reports
      class SalesSummary < Api::Action
        include Deps["persistence.repositories.sales_repo"]
        
        def handle(request, response)

          start_date = parse_date(request.params[:start_date])
          end_date = parse_date(request.params[:end_date])
          

          summary = sales_repo.sales_summary(start_date: start_date, end_date: end_date) || {}
          by_channel = sales_repo.sales_by_channel(start_date: start_date, end_date: end_date)
          by_region = sales_repo.sales_by_region(start_date: start_date, end_date: end_date)
          

          total_discount = (summary[:total_subtotal].to_f - summary[:total_sales].to_f).round(2)
          discount_percentage = summary[:total_subtotal].to_f > 0 ? 
            ((total_discount / summary[:total_subtotal].to_f) * 100).round(2) : 0
          
          response_data = {
            period: {
              start_date: start_date&.to_s || "N/A",
              end_date: end_date&.to_s || "N/A",
              note: start_date && end_date ? "Filtrado por período" : "Todos os dados"
            },
            summary: {
              total_sales: summary[:total_sales]&.to_f&.round(2) || 0,
              total_transactions: summary[:total_transactions] || 0,
              average_sale: summary[:average_sale]&.to_f&.round(2) || 0,
              total_discount: total_discount,
              discount_percentage: discount_percentage,
              total_subtotal: summary[:total_subtotal]&.to_f&.round(2) || 0
            },
            by_channel: format_channel_data(by_channel),
            by_region: format_region_data(by_region),
            metadata: {
              generated_at: Time.now.iso8601,
              data_source: "database",
              record_count: summary[:total_transactions] || 0
            }
          }
          

          if summary[:total_transactions].to_i == 0
            response_data[:note] = "Sem dados no banco. Usando dados de demonstração."
            response_data[:summary] = {
              total_sales: 154280.75,
              total_transactions: 1256,
              average_sale: 122.83,
              total_discount: 18513.69,
              discount_percentage: 12.0,
              total_subtotal: 172794.44
            }
          end
          
          json_response(response_data)
        end
        
        private
        
        def parse_date(date_str)
          return nil if date_str.to_s.empty?
          Date.parse(date_str) rescue nil
        end
        
        def format_channel_data(channel_data)
          return {} if channel_data.empty?
          
          channel_data.each_with_object({}) do |channel, hash|
            hash[channel.sales_channel] = {
              total_sales: channel.total_sales.to_f.round(2),
              transaction_count: channel.transaction_count,
              average_sale: channel.average_sale.to_f.round(2),
              percentage: calculate_percentage(channel.total_sales.to_f, channel_data.sum(&:total_sales))
            }
          end
        end
        
        def format_region_data(region_data)
          return {} if region_data.empty?
          
          region_data.each_with_object({}) do |region, hash|
            hash[region.region] = {
              total_sales: region.total_sales.to_f.round(2),
              transaction_count: region.transaction_count,
              average_sale: region.average_sale.to_f.round(2)
            }
          end
        end
        
        def calculate_percentage(value, total)
          total > 0 ? ((value / total) * 100).round(2) : 0
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
