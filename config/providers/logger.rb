Hanami.app.register_provider(:logger) do
  start do
    root = Hanami.app.root
    # Logger padrão (Console e App)
    logger = Logger.new(root.join("log", "app.log"))
    register :logger, logger

    # Logger específico para processamento de arquivos
    file_logger = Logger.new(root.join("log", "processing.log"))
    register :file_logger, file_logger
  end
end
