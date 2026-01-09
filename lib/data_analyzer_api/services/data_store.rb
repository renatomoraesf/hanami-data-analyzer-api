module DataAnalyzerApi
  module Services
    class DataStore
      def initialize
        @store = {
          sales: [],
          customers: [],
          products: []
        }
      end
      
      def add_sales(data)
        @store[:sales] = data
      end
      
      def all_sales
        @store[:sales]
      end
      
      def clear
        @store.each { |key, _| @store[key] = [] }
      end
    end
  end
end