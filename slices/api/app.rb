module API
  class Slice < Hanami::Slice

    import from: :actions, as: :actions
    

    config.logger.level = :debug
    

    container do

      register "persistence.repositories.sales_repo", Api::Persistence::Repositories::SalesRepo
      
 
      register "services.demographic_calculator", DataAnalyzerApi::Services::DemographicCalculator
      register "services.regional_calculator", DataAnalyzerApi::Services::RegionalCalculator
    end
  end
end
