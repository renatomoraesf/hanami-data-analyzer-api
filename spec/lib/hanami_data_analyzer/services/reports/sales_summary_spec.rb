RSpec.describe HanamiDataAnalyzer::Services::Reports::SalesSummary do
  let(:sample_data) do
    [
      {
        id_transacao: "TXN00000001",
        data_venda: "2023-01-15",
        valor_final: "100.50",
        subtotal: "120.00",
        desconto_percent: "10",
        canal_venda: "Online",
        forma_pagamento: "Cartão Crédito"
      },
      {
        id_transacao: "TXN00000002",
        data_venda: "2023-01-16",
        valor_final: "200.00",
        subtotal: "200.00",
        desconto_percent: "0",
        canal_venda: "Loja Física",
        forma_pagamento: "PIX"
      },
      {
        id_transacao: "TXN00000003",
        data_venda: "2023-02-01",
        valor_final: "150.75",
        subtotal: "180.00",
        desconto_percent: "15",
        canal_venda: "Online",
        forma_pagamento: "Cartão Débito"
      }
    ]
  end
  
  describe "#call" do
    context "with empty data" do
      it "returns empty response" do
        service = described_class.new(data: [])
        result = service.call
        
        expect(result[:summary][:total_sales]).to eq(0)
        expect(result[:summary][:total_transactions]).to eq(0)
      end
    end
    
    context "with sample data" do
      it "calculates correct totals" do
        service = described_class.new(data: sample_data)
        result = service.call
        
        expect(result[:summary][:total_sales]).to eq(451.25) # 100.50 + 200.00 + 150.75
        expect(result[:summary][:total_transactions]).to eq(3)
        expect(result[:summary][:average_sale]).to eq(150.42)
      end
      
      it "groups by channel correctly" do
        service = described_class.new(data: sample_data)
        result = service.call
        
        expect(result[:by_channel]["Online"][:transaction_count]).to eq(2)
        expect(result[:by_channel]["Loja Física"][:transaction_count]).to eq(1)
      end
      
      it "groups by period correctly" do
        service = described_class.new(data: sample_data)
        result = service.call
        
        expect(result[:by_period].keys).to include("2023-01", "2023-02")
      end
    end
  end
end