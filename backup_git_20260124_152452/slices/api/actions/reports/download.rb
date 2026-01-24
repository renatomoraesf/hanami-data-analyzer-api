module Api
  module Actions
    module Reports
      class Download < Api::Action
        include Deps[
          "persistence.repositories.sales_repo",
          "services.json_exporter",
          "services.pdf_exporter"
        ]
        
        params do
          required(:format).filled(:string, included_in?: ["json", "pdf"])
        end

        def handle(request, response)
          validation = validate_params(request.params)
          return error_response(response, validation.errors) if validation.failure?

          case request.params[:format]
          when "json"
            export_json(response)
          when "pdf"
            export_pdf(response)
          end
        end

        private

        def export_json(response)
          data = json_exporter.export_full_report
          
          response.headers["Content-Type"] = "application/json"
          response.headers["Content-Disposition"] = "attachment; filename=report_#{Time.now.to_i}.json"
          response.body = JSON.pretty_generate(data)
        end

        def export_pdf(response)
          pdf_data = pdf_exporter.generate_report
          
          response.headers["Content-Type"] = "application/pdf"
          response.headers["Content-Disposition"] = "attachment; filename=report_#{Time.now.to_i}.pdf"
          response.body = pdf_data
        end
        
      end
    end
  end
end