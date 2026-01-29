# lib/data_analyzer_api/services/pdf_exporter.rb
require "prawn"
require "prawn/table"

module DataAnalyzerApi
  module Services
    class PdfExporter
      def call(data)
        Prawn::Document.new do |pdf|
          pdf.text "Projeto Hanami - Relatório Analítico", size: 25, style: :bold, align: :center
          pdf.move_down 20


          pdf.text "Métricas Financeiras", size: 18, style: :bold
          finance = data[:financial_metrics]
          pdf.table([
            ["Receita Líquida", "R$ #{finance[:receita_liquida]}"],
            ["Lucro Bruto", "R$ #{finance[:lucro_bruto]}"],
            ["Custo Total", "R$ #{finance[:custo_total]}"]
          ], width: 500)

          pdf.move_down 30

          # Tabela de Produtos
          pdf.text "Análise de Produtos", size: 18, style: :bold
          product_rows = [["Produto", "Quantidade", "Total"]]
          data[:products].each do |p|
            product_rows << [p[:nome], p[:quantidade], "R$ #{p[:total]}"]
          end
          pdf.table(product_rows, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: 500)

          pdf.move_down 20
          pdf.text "Gerado em: #{Time.now.strftime('%d/%m/%Y %H:%M')}", size: 10, style: :italic
        end.render
      end
    end
  end
end
