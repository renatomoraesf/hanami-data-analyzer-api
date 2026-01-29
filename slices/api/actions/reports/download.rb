# slices/api/actions/reports/download.rb
require "hanami/action"
require "dry/auto_inject"

module API
  module Actions
    module Reports
      class Download < Hanami::Action
        include Dry::AutoInject(Hanami.app)[
          "data_analyzer_api.services.report_generator",
          "data_analyzer_api.services.pdf_exporter"
        ]

        params do
          required(:format).filled(:string, included_in?: %w[json pdf])
        end

        def handle(request, response)
          unless request.params.valid?
            response.status = 400
            response.body = { error: "Formato inválido. Use 'json' ou 'pdf'" }.to_json
            response.headers["Content-Type"] = "application/json"
            return
          end


          report_data = report_generator.generate_all_reports

          case request.params[:format]
          when "json"
            response.headers["Content-Type"] = "application/json"
            response.headers["Content-Disposition"] = "attachment; filename=report.json"
            response.body = report_data.to_json
          when "pdf"
            response.headers["Content-Type"] = "application/pdf"
            response.headers["Content-Disposition"] = "attachment; filename=report.pdf"
            response.body = pdf_exporter.call(report_data)
          end
        end
      end
    end
  end
end
