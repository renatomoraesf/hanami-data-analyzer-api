# lib/data_analyzer_api/persistence/repositories/file_processing_repo.rb
module DataAnalyzerApi
  module Persistence
    module Repositories
      class FileProcessingRepo < ROM::Repository[:file_processings]
        include Import["persistence.rom"]

        commands :create, update: :by_pk

        def create_processing(filename, status: 'pending')
          create(filename: filename, status: status, processed_at: Time.now)
        end

        def update_processing(id, attributes)
          update(id, attributes.merge(updated_at: Time.now))
        end
      end
    end
  end
end
