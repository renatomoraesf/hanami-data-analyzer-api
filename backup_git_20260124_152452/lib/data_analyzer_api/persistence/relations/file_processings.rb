# lib/data_analyzer_api/persistence/relations/file_processings.rb
module DataAnalyzerApi
  module Persistence
    module Relations
      class FileProcessings < ROM::Relation[:sql]
        schema(:file_processings, infer: true)
      end
    end
  end
end
