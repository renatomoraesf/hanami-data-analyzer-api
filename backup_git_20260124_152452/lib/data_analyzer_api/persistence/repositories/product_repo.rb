module DataAnalyzerApi
  module Persistence
    module Repositories
      class ProductRepo < Repository
        commands :create

        def find_or_create(product_data)
          product = products.where(produto_id: product_data[:produto_id]).one
          product || create(product_data)
        end

        def find_by_product_id(product_id)
          products.where(produto_id: product_id).one
        end
      end
    end
  end
end
