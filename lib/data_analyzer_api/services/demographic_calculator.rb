module DataAnalyzerApi
  module Services
    class DemographicCalculator
      def initialize(sales_data)
        @sales_data = sales_data
      end

      def gender_distribution
        distribution = @sales_data.group(:customer_gender).count
        total = distribution.values.sum
        
        distribution.transform_values do |count|
          {
            count: count,
            percentage: total.zero? ? 0 : ((count.to_f / total) * 100).round(2)
          }
        end
      end

      def age_distribution
        
        age_groups = {
          "18-25" => 0,
          "26-35" => 0,
          "36-45" => 0,
          "46-55" => 0,
          "56-70" => 0
        }
        
        @sales_data.each do |sale|
          age = sale.customer_age
          case age
          when 18..25 then age_groups["18-25"] += 1
          when 26..35 then age_groups["26-35"] += 1
          when 36..45 then age_groups["36-45"] += 1
          when 46..55 then age_groups["46-55"] += 1
          when 56..70 then age_groups["56-70"] += 1
          end
        end
        
        total = age_groups.values.sum
        age_groups.transform_values do |count|
          {
            count: count,
            percentage: total.zero? ? 0 : ((count.to_f / total) * 100).round(2)
          }
        end
      end

      def city_distribution(limit = 10)
        distribution = @sales_data.group(:customer_city).count
        distribution.sort_by { |_, count| -count }.first(limit).to_h
      end

      def state_distribution
        @sales_data.group(:customer_state).count
      end
    end
  end
end