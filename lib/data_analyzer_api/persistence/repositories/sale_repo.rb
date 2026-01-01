module DataAnalyzerApi
  module Persistence
    module Repositories
      class SaleRepo < Repository
        commands :create

        associations do
          belongs_to :customer, as: :customer_rel, foreign_key: :cliente_id
          belongs_to :product, as: :product_rel, foreign_key: :produto_id
        end

        def create_with_associations(data)
          command(:create).call(data)
        end
        def batch_create(sales_data)
          sales_data.each do |sale|
            create(sale)
          end
        end

        def find_by_transaction_id(transaction_id)
          sales.where(id_transacao: transaction_id).one
        end

        def sales_by_date_range(start_date, end_date)
          sales.where { data_venda >= start_date & data_venda <= end_date }.to_a
        end
      end
    end
  end
end
