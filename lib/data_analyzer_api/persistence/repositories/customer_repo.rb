module DataAnalyzerApi
  module Persistence
    module Repositories
      class CustomerRepo < Repository
        commands :create

        def find_or_create(customer_data)
          customer = customers.where(cliente_id: customer_data[:cliente_id]).one
          customer || create(customer_data)
        end

        def find_by_customer_id(customer_id)
          customers.where(cliente_id: customer_id).one
        end
      end
    end
  end
end
