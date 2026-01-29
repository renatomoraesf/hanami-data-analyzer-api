module API
  module Actions
    module Reports
      class RegionalPerformance < Api::Action
        include Deps["persistence.repositories.sales_repo"]
        
        def handle(request, response)
          start_date = parse_date(request.params[:start_date])
          end_date = parse_date(request.params[:end_date])
          
          data = sales_repo.regional_performance(
            start_date: start_date,
            end_date: end_date
          )
          

          formatted_data = data.map do |region|
            {
              region: region.region,
              metrics: {
                total_sales: region.total_sales.to_f.round(2),
                transaction_count: region.transaction_count,
                average_sale: region.average_sale.to_f.round(2),
                avg_delivery_days: region.avg_delivery_days.to_f.round(1),
                total_units: region.total_units
              },
              market_share: calculate_percentage(
                region.total_sales.to_f,
                data.sum { |r| r.total_sales.to_f }
              )
            }
          end
          
          json_response({
            report: "Regional Performance",
            period: format_period(start_date, end_date),
            regions: formatted_data,
            summary: {
              total_regions: formatted_data.size,
              national_total: data.sum { |r| r.total_sales.to_f }.round(2),
              avg_regional_sales: (data.sum { |r| r.total_sales.to_f } / formatted_data.size).round(2),
              best_performing: formatted_data.first&.dig(:region) || "N/A"
            },
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
        
        def json_response(data, status: 200)
          self.status = status
          self.body = data.to_json
          headers["Content-Type"] = "application/json"
        end
      end
    end
  end
end
