# db/migrate/002_create_file_processings.rb
ROM::SQL.migration do
  change do
    create_table :file_processings do
      primary_key :id
      column :filename, String, null: false
      column :status, String, null: false, default: 'pending'
      column :rows_processed, Integer
      column :valid_rows, Integer
      column :errors, :jsonb
      column :processed_at, DateTime
      column :created_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
