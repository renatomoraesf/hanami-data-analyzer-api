ROM::SQL.migration do
  change do
    # Tabela de clientes
    create_table :customers do
      primary_key :id
      column :cliente_id, String, null: false, unique: true
      column :nome_cliente, String, null: false
      column :idade_cliente, Integer
      column :genero_cliente, String, size: 1
      column :cidade_cliente, String
      column :estado_cliente, String, size: 2
      column :renda_estimada, Float
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end

    # Tabela de produtos
    create_table :products do
      primary_key :id
      column :produto_id, String, null: false, unique: true
      column :nome_produto, String, null: false
      column :categoria, String
      column :marca, String
      column :preco_unitario, Float, null: false
      column :quantidade, Integer
      column :margem_lucro, Float
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end

    # Tabela de vendas
    create_table :sales do
      primary_key :id
      column :id_transacao, String, null: false, unique: true
      column :data_venda, Date, null: false
      column :valor_final, Float, null: false
      column :subtotal, Float, null: false
      column :desconto_percent, Float
      column :canal_venda, String
      column :forma_pagamento, String
      column :regiao, String
      column :status_entrega, String
      column :tempo_entrega_dias, Integer
      column :vendedor_id, String
      column :cliente_id, String
      column :produto_id, String
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false

      foreign_key :cliente_id, :customers, key: :cliente_id, type: String
      foreign_key :produto_id, :products, key: :produto_id, type: String
    end

    # Índices para performance
    run "CREATE INDEX idx_sales_id_transacao ON sales(id_transacao);"
    run "CREATE INDEX idx_sales_data_venda ON sales(data_venda);"
    run "CREATE INDEX idx_sales_regiao ON sales(regiao);"
    run "CREATE INDEX idx_sales_canal_venda ON sales(canal_venda);"
    run "CREATE INDEX idx_customers_cliente_id ON customers(cliente_id);"
    run "CREATE INDEX idx_products_produto_id ON products(produto_id);"
    run "CREATE INDEX idx_sales_cliente_id ON sales(cliente_id);"
    run "CREATE INDEX idx_sales_produto_id ON sales(produto_id);"
  end
end
