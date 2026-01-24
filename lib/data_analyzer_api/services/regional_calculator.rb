module DataAnalyzerApi
  module Services
    class RegionalCalculator
      REGIONS = {
        "Norte" => ["AC", "AP", "AM", "PA", "RO", "RR", "TO"],
        "Nordeste" => ["AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE"],
        "Centro-Oeste" => ["DF", "GO", "MT", "MS"],
        "Sudeste" => ["ES", "MG", "RJ", "SP"],
        "Sul" => ["PR", "RS", "SC"]
      }.freeze

      def initialize(sales_data)
        @sales_data = sales_data
      end

      def performance_by_region
        results = {}
        
        REGIONS.each do |region_name, states|
          region_sales = @sales_data.where(customer_state: states)
          
          results[region_name] = {
            total_sales: region_sales.sum(:final_value),
            transaction_count: region_sales.count,
            average_sale: region_sales.average(:final_value),
            top_product: top_product_in_region(region_sales),
            delivery_performance: delivery_performance(region_sales),
            customer_count: region_sales.distinct.count(:customer_id)
          }
        end
        
        results
      end

      def performance_by_state(region = nil)
        scope = @sales_data
        scope = scope.where(customer_state: REGIONS[region]) if region
        
        scope.group(:customer_state).select do |state, sales|
          {
            state: state,
            total_sales: sales.sum(&:final_value),
            transaction_count: sales.count,
            average_delivery_days: sales.average(&:delivery_days),
            top_city: sales.group_by(&:customer_city).max_by { |_, s| s.count }&.first
          }
        end
      end

      private

      def top_product_in_region(sales)
        sales.group_by(&:product_name)
             .max_by { |_, s| s.sum(&:final_value) }
             &.first
      end

      def delivery_performance(sales)
        on_time = sales.count { |s| s.delivery_status == "Entregue" && s.delivery_days <= 7 }
        total = sales.count
        
        {
          on_time_percentage: total.zero? ? 0 : ((on_time.to_f / total) * 100).round(2),
          average_days: sales.average(:delivery_days).to_f.round(2),
          status_distribution: sales.group(:delivery_status).count
        }
      end
    end
  end
end