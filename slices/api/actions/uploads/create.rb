# auto_register: false
module Api
  module Actions
    module Uploads
      class Create < Api::Action
        def handle(request, response)
          response.body = {
            message: "Upload endpoint pronto para implementação",
            status: "implementação em progresso",
            next_steps: [
              "Integrar CSV parser",
              "Adicionar validação",
              "Conectar ao banco de dados"
            ]
          }.to_json
        end
      end
    end
  end
end
