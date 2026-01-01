module DataAnalyzerApi
  module Validators
    class CsvValidator
      REQUIRED_SALE_COLUMNS = %w[
        id_transacao data_venda valor_final subtotal 
        desconto_percent canal_venda forma_pagamento
        regiao status_entrega tempo_entrega_dias
        vendedor_id cliente_id produto_id
      ].freeze
      
      CHANNELS = ['Online', 'Loja Física', 'Marketplace', 'Telefone', 'App Mobile'].freeze
      PAYMENT_METHODS = ['Cartão Crédito', 'Cartão Débito', 'PIX', 'Boleto'].freeze
      REGIONS = ['Norte', 'Nordeste', 'Centro-Oeste', 'Sudeste', 'Sul'].freeze
      DELIVERY_STATUS = ['Entregue', 'Em Trânsito', 'Processando'].freeze
      
      def call(data)
        return { valid: false, errors: ["No data provided"] } if data[:sales].empty?
        
        errors = []
        
        # Validar vendas
        data[:sales].each_with_index do |sale, index|
          sale_errors = validate_sale(sale, index + 2) # +2 for header row
          errors.concat(sale_errors) if sale_errors.any?
        end
        
        # Validar clientes
        data[:customers].each_with_index do |customer, index|
          customer_errors = validate_customer(customer, index + 2)
          errors.concat(customer_errors) if customer_errors.any?
        end
        
        # Validar produtos
        data[:products].each_with_index do |product, index|
          product_errors = validate_product(product, index + 2)
          errors.concat(product_errors) if product_errors.any?
        end
        
        { valid: errors.empty?, errors: errors }
      end
      
      private
      
      def validate_sale(sale, line_number)
        errors = []
        
        # Campos obrigatórios
        REQUIRED_SALE_COLUMNS.each do |column|
          if sale[column.to_sym].nil? || sale[column.to_sym].to_s.empty?
            errors << "Linha #{line_number}: Campo '#{column}' é obrigatório"
          end
        end
        
        # Validações específicas
        if sale[:desconto_percent] && (sale[:desconto_percent] < 0 || sale[:desconto_percent] > 100)
          errors << "Linha #{line_number}: desconto_percent deve estar entre 0 e 100"
        end
        
        if sale[:valor_final] && sale[:valor_final] < 0
          errors << "Linha #{line_number}: valor_final não pode ser negativo"
        end
        
        if sale[:tempo_entrega_dias] && (sale[:tempo_entrega_dias] < 1 || sale[:tempo_entrega_dias] > 15)
          errors << "Linha #{line_number}: tempo_entrega_dias deve estar entre 1 e 15"
        end
        
        # Validações de domínio
        if sale[:canal_venda] && !CHANNELS.include?(sale[:canal_venda])
          errors << "Linha #{line_number}: canal_venda inválido. Valores permitidos: #{CHANNELS.join(', ')}"
        end
        
        if sale[:forma_pagamento] && !PAYMENT_METHODS.include?(sale[:forma_pagamento])
          errors << "Linha #{line_number}: forma_pagamento inválida. Valores permitidos: #{PAYMENT_METHODS.join(', ')}"
        end
        
        if sale[:regiao] && !REGIONS.include?(sale[:regiao])
          errors << "Linha #{line_number}: regiao inválida. Valores permitidos: #{REGIONS.join(', ')}"
        end
        
        if sale[:status_entrega] && !DELIVERY_STATUS.include?(sale[:status_entrega])
          errors << "Linha #{line_number}: status_entrega inválido. Valores permitidos: #{DELIVERY_STATUS.join(', ')}"
        end
        
        errors
      end
      
      def validate_customer(customer, line_number)
        errors = []
        
        if customer[:idade_cliente] && (customer[:idade_cliente] < 18 || customer[:idade_cliente] > 70)
          errors << "Linha #{line_number}: idade_cliente deve estar entre 18 e 70"
        end
        
        if customer[:genero_cliente] && !['M', 'F'].include?(customer[:genero_cliente])
          errors << "Linha #{line_number}: genero_cliente deve ser 'M' ou 'F'"
        end
        
        if customer[:renda_estimada] && (customer[:renda_estimada] < 2000 || customer[:renda_estimada] > 20000)
          errors << "Linha #{line_number}: renda_estimada deve estar entre 2000 e 20000"
        end
        
        errors
      end
      
      def validate_product(product, line_number)
        errors = []
        
        if product[:margem_lucro] && (product[:margem_lucro] < 15 || product[:margem_lucro] > 60)
          errors << "Linha #{line_number}: margem_lucro deve estar entre 15 e 60"
        end
        
        if product[:preco_unitario] && product[:preco_unitario] <= 0
          errors << "Linha #{line_number}: preco_unitario deve ser maior que 0"
        end
        
        errors
      end
    end
  end
end
