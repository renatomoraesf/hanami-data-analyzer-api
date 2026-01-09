# config/providers/persistence.rb
Hanami.app.register_provider :persistence, namespace: true do
  prepare do
    require "rom"

    config = ROM::Configuration.new(:sql, target["settings"].database_url)

    # Registrar relações
    config.auto_registration(
      target.root.join("lib/data_analyzer_api/persistence"),
      namespace: "DataAnalyzerApi::Persistence"
    )

    register "config", config
    register "rom", ROM.container(config)
  end

  start do
    rom = target["persistence.rom"]

    # Carregar migrations
    rom.gateways[:default].use_logger(target["logger"]) if Hanami.env == :development

    register "rom", rom
  end
end
