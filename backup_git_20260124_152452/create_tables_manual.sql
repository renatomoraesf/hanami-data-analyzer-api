\c data_analyzer_api_dev

CREATE TABLE IF NOT EXISTS sales (
    id SERIAL PRIMARY KEY,
    id_transacao VARCHAR(50) UNIQUE NOT NULL,
    data_venda DATE NOT NULL,
    valor_final DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    desconto_percent DECIMAL(5,2),
    canal_venda VARCHAR(50),
    forma_pagamento VARCHAR(50),
    regiao VARCHAR(50),
    status_entrega VARCHAR(50),
    tempo_entrega_dias INTEGER,
    vendedor_id VARCHAR(50),
    cliente_id VARCHAR(50),
    produto_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,
    cliente_id VARCHAR(50) UNIQUE NOT NULL,
    nome_cliente VARCHAR(100) NOT NULL,
    idade_cliente INTEGER,
    genero_cliente CHAR(1),
    cidade_cliente VARCHAR(100),
    estado_cliente VARCHAR(2),
    renda_estimada DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    produto_id VARCHAR(50) UNIQUE NOT NULL,
    nome_produto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    marca VARCHAR(50),
    preco_unitario DECIMAL(10,2) NOT NULL,
    quantidade INTEGER,
    margem_lucro DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
