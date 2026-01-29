# slices/api/actions/reports/product_analysis.rb
module API
  module Actions
    module Reports
      class ProductAnalysis < Api::Action
        include Deps["persistence.repositories.sales_repo"]
        
        def handle(request, response)
          start_date = parse_date(request.params[:start_date])
          end_date = parse_date(request.params[:end_date])
          limit = (request.params[:limit] || 20).to_i
          

          products = sales_repo.product_analysis(
            start_date: start_date,
            end_date: end_date,
            limit: limit
          )
          

          categories = sales_repo.category_analysis(
            start_date: start_date,
            end_date: end_date
          )
          

          total_sales = products.sum { |p| p.total_sales.to_f }
          total_units = products.sum { |p| p.total_units.to_i }
          
          formatted_products = products.map.with_index(1) do |product, rank|
            {
              rank: rank,
              product_id: product.product_id,
              product_name: product.product_name,
              category: product.product_category,
              brand: product.product_brand,
              metrics: {
                total_sales: product.total_sales.to_f.round(2),
                total_units: product.total_units,
                transaction_count: product.transaction_count,
                average_price: product.average_price.to_f.round(2),
                avg_profit_margin: product.avg_profit_margin.to_f.round(1),
                estimated_profit: product.estimated_profit.to_f.round(2)
              },
              market_share: calculate_percentage(product.total_sales.to_f, total_sales)
            }
          end
          
          formatted_categories = categories.map do |category|
            {
              category: category.product_category,
              total_sales: category.total_sales.to_f.round(2),
              total_units: category.total_units,
              transaction_count: category.transaction_count,
              avg_profit_margin: category.avg_profit_margin.to_f.round(1),
              category_share: calculate_percentage(category.total_sales.to_f, total_sales)
            }
          end
          
          json_response({
            report: "Product Analysis",
            period: format_period(start_date, end_date),
            top_products: {
              count: formatted_products.size,
              products: formatted_products,
              summary: {
                total_sales: total_sales.round(2),
                total_units: total_units,
                avg_profit_margin: (products.sum { |p| p.avg_profit_margin.to_f } / products.size).round(1)
              }
            },
            category_analysis: {
              categories: formatted_categories,
              top_category: formatted_categories.first&.dig(:category) || "N/A"
            },
            insights: generate_insights(products, categories),
            metadata: {
              generated_at: Time.now.iso8601,
              limit_applied: limit,
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
        
        def generate_insights(products, categories)
          insights = []
          
          if products.any?
            top_product = products.first
            insights << "Top product: #{top_product.product_name} with #{top_product.total_sales.to_f.round(2)} in sales"
            
            if products.size >= 3
              top_3_sales = products.first(3).sum { |p| p.total_sales.to_f }
              total_sales = products.sum { |p| p.total_sales.to_f }
              percentage = (top_3_sales / total_sales * 100).round(1)
              insights << "Top 3 products represent #{percentage}% of total sales"
            end
          end
          
          if categories.any?
            top_category = categories.first
            insights << "Top category: #{top_category.product_category} with #{top_category.total_sales.to_f.round(2)} in sales"
          end
          
          insights
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
