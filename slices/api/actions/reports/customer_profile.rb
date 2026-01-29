# slices/api/actions/reports/customer_profile.rb
module API
  module Actions
    module Reports
      class CustomerProfile < Api::Action
        include Deps["persistence.repositories.sales_repo"]
        
        def handle(request, response)
          start_date = parse_date(request.params[:start_date])
          end_date = parse_date(request.params[:end_date])
          
          profile_data = sales_repo.customer_profile(
            start_date: start_date,
            end_date: end_date
          )
          
          demographics = profile_data[:demographics].map do |demo|
            {
              gender: demo.customer_gender,
              customer_count: demo.customer_count,
              total_spent: demo.total_spent.to_f.round(2),
              avg_age: demo.avg_age.to_f.round(1),
              avg_income: demo.avg_income.to_f.round(2),
              avg_spent_per_customer: (demo.total_spent.to_f / demo.customer_count).round(2)
            }
          end
          
          top_cities = profile_data[:top_cities].map do |city|
            {
              city: city.customer_city,
              state: city.customer_state,
              transaction_count: city.transaction_count,
              total_sales: city.total_sales.to_f.round(2),
              unique_customers: city.unique_customers,
              avg_sale_per_customer: (city.total_sales.to_f / city.unique_customers).round(2)
            }
          end
          
          age_distribution = profile_data[:age_distribution].map do |age|
            {
              age_bracket: age.age_bracket,
              customer_count: age.customer_count,
              total_spent: age.total_spent.to_f.round(2),
              avg_spent_per_customer: (age.total_spent.to_f / age.customer_count).round(2)
            }
          end
          
          total_customers = profile_data[:total_unique_customers] || 0
          total_sales = demographics.sum { |d| d[:total_spent] }
          
          json_response({
            report: "Customer Profile Analysis",
            period: format_period(start_date, end_date),
            customer_base: {
              total_unique_customers: total_customers,
              total_transactions: demographics.sum { |d| d[:customer_count] },
              total_sales: total_sales,
              avg_transaction_value: total_customers > 0 ? (total_sales / total_customers).round(2) : 0
            },
            demographics: {
              by_gender: demographics,
              total_customers_by_gender: demographics.sum { |d| d[:customer_count] }
            },
            geographic_distribution: {
              top_cities: top_cities,
              cities_analyzed: top_cities.size
            },
            age_analysis: {
              distribution: age_distribution,
              most_popular_bracket: age_distribution.max_by { |a| a[:customer_count] }&.dig(:age_bracket) || "N/A"
            },
            insights: generate_customer_insights(demographics, top_cities, age_distribution),
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
        
        def generate_customer_insights(demographics, cities, ages)
          insights = []
          
          if demographics.any?

            gender_data = demographics.group_by { |d| d[:gender] }
            if gender_data['M'] && gender_data['F']
              male_count = gender_data['M'].sum { |d| d[:customer_count] }
              female_count = gender_data['F'].sum { |d| d[:customer_count] }
              total = male_count + female_count
              
              if total > 0
                male_pct = (male_count.to_f / total * 100).round(1)
                female_pct = (female_count.to_f / total * 100).round(1)
                insights << "Customer base: #{male_pct}% male, #{female_pct}% female"
              end
            end
            
            if demographics.any?
              highest_spending = demographics.max_by { |d| d[:avg_spent_per_customer] }
              insights << "Highest average spend: #{highest_spending[:gender]} customers at #{highest_spending[:avg_spent_per_customer]} per customer"
            end
          end
          
          if cities.any?
            top_city = cities.first
            insights << "Top city by sales: #{top_city[:city]}, #{top_city[:state]} with #{top_city[:total_sales]} in sales"
          end
          
          if ages.any?
            largest_age_group = ages.max_by { |a| a[:customer_count] }
            insights << "Largest age group: #{largest_age_group[:age_bracket]} with #{largest_age_group[:customer_count]} customers"
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
