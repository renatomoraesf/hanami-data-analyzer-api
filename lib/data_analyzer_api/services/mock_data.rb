module DataAnalyzerApi
  module Services
    class MockData
      def self.sales_data
        [
          {
            id_transacao: "TXN00000001",
            data_venda: "2024-01-10",
            valor_final: "1500.75",
            subtotal: "1650.00",
            desconto_percent: "10",
            canal_venda: "Online",
            forma_pagamento: "Cartão Crédito",
            cliente_id: "CLI000001",
            produto_id: "PRD001"
          },
          {
            id_transacao: "TXN00000002",
            data_venda: "2024-01-11",
            valor_final: "890.50",
            subtotal: "890.50",
            desconto_percent: "0",
            canal_venda: "Loja Física",
            forma_pagamento: "PIX",
            cliente_id: "CLI000002",
            produto_id: "PRD002"
          },
          {
            id_transacao: "TXN00000003",
            data_venda: "2024-01-12",
            valor_final: "3200.00",
            subtotal: "4000.00",
            desconto_percent: "20",
            canal_venda: "Marketplace",
            forma_pagamento: "Boleto",
            cliente_id: "CLI000003",
            produto_id: "PRD003"
          },
          {
            id_transacao: "TXN00000004",
            data_venda: "2024-01-12",
            valor_final: "750.25",
            subtotal: "880.00",
            desconto_percent: "15",
            canal_venda: "Online",
            forma_pagamento: "Cartão Débito",
            cliente_id: "CLI000004",
            produto_id: "PRD004"
          },
          {
            id_transacao: "TXN00000005",
            data_venda: "2024-01-13",
            valor_final: "1200.00",
            subtotal: "1200.00",
            desconto_percent: "0",
            canal_venda: "App Mobile",
            forma_pagamento: "PIX",
            cliente_id: "CLI000005",
            produto_id: "PRD005"
          }
        ]
      end
    end
  end
end