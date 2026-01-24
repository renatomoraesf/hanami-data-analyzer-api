module Api
  class Slice < Hanami::Slice
    # Importar actions do slice
    import from: :actions, as: :actions
    
    # Configurações do slice
    config.logger.level = :debug
    
    # Container de dependências
    container do
      # Registrar repositórios
      register "persistence.repositories.sales_repo", Api::Persistence::Repositories::SalesRepo
      
      # Registrar serviços (adicionar aqui os novos serviços)
      register "services.demographic_calculator", DataAnalyzerApi::Services::DemographicCalculator
      register "services.regional_calculator", DataAnalyzerApi::Services::RegionalCalculator
    end
  end
end
