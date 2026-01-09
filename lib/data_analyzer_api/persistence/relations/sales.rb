# lib/data_analyzer_api/persistence/relations/sales.rb
module DataAnalyzerApi
  module Persistence
    module Relations
      class Sales < ROM::Relation[:sql]
        schema(:sales, infer: true) do
          associations do
            # Podemos adicionar associações aqui se necessário
          end
        end

        # Scopes úteis
        def by_date_range(start_date, end_date)
          where { sale_date >= start_date }.where { sale_date <= end_date }
        end

        def by_channel(channel)
          where(sales_channel: channel)
        end

        def by_region(region)
          where(region: region)
        end

        def summary_stats
          select {
            [
              function(:count, :id).as(:total_transactions),
              function(:sum, :final_value).as(:total_sales),
              function(:avg, :final_value).as(:average_sale),
              function(:sum, :subtotal).as(:total_subtotal),
              function(:sum, sequel.lit('subtotal - final_value')).as(:total_discount)
            ]
          }.first
        end
      end
    end
  end
end
