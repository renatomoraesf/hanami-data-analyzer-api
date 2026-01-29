# db/migrate/001_create_sales.rb
ROM::SQL.migration do
  change do
    create_table :sales do
      primary_key :id
      column :transaction_id, String, null: false, unique: true
      column :sale_date, Date, null: false
      column :final_value, Decimal, precision: 10, scale: 2, null: false
      column :subtotal, Decimal, precision: 10, scale: 2, null: false
      column :discount_percent, Integer, null: false
      column :sales_channel, String, null: false
      column :payment_method, String, null: false
      
      # Cliente
      column :customer_id, String, null: false
      column :customer_name, String, null: false
      column :customer_age, Integer, null: false
      column :customer_gender, String, null: false
      column :customer_city, String, null: false
      column :customer_state, String, null: false
      column :customer_income, Decimal, precision: 10, scale: 2, null: false
      
      # Produto
      column :product_id, String, null: false
      column :product_name, String, null: false
      column :product_category, String, null: false
      column :product_brand, String, null: false
      column :unit_price, Decimal, precision: 10, scale: 2, null: false
      column :quantity, Integer, null: false
      column :profit_margin, Integer, null: false
      
      # Logística
      column :region, String, null: false
      column :delivery_status, String, null: false
      column :delivery_days, Integer, null: false
      column :seller_id, String, null: false
      
      # Timestamps
      column :created_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
      
      # Índices
      index :transaction_id, unique: true
      index :sale_date
      index :sales_channel
      index :customer_id
      index :product_id
      index :region
    end
  end
end
