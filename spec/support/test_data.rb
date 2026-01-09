module TestData
  def self.sales_sample

    10.times.map do |i|
      {
        id_transacao: "TXN#{i.to_s.rjust(8, '0')}",
        data_venda: Date.today.prev_day(i).to_s,
        valor_final: rand(50.0..500.0).round(2),
        subtotal: rand(60.0..600.0).round(2),
        desconto_percent: rand(0..30),
        canal_venda: ["Online", "Loja Física", "Marketplace"].sample,
        forma_pagamento: ["Cartão Crédito", "PIX", "Boleto"].sample,
        cliente_id: "CLI#{rand(1000..9999)}",
        produto_id: "PRD#{rand(100..999)}"
      }
    end
  end
end