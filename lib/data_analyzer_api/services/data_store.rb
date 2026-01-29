module DataAnalyzerApi
  module Services
    class DataStore
      def initialize
        @data = {}
      end
      
      def store(key, value)
        @data[key] = value
      end
      
      def retrieve(key)
        @data[key]
      end
      
      def clear
        @data.clear
      end
    end
  end
end
