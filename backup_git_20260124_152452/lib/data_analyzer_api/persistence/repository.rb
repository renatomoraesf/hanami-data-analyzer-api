module DataAnalyzerApi
  module Persistence
    class Repository < Hanami::Repository
      def count
        root.count
      end
      
      def find_by_id(id)
        root.by_pk(id).one
      end
      def create(data)
        root.command(:create).call(data)
      end
      
      def update(id, data)
        root.by_pk(id).command(:update).call(data)
      end
      
      def delete(id)
        root.by_pk(id).command(:delete).call
      end
    end
  end
end
