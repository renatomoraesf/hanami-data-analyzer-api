Hanami.app.register_provider(:file_logger) do
  prepare do
    require "hanami/logger"
    
    log_dir = File.join(Dir.pwd, "log")
    FileUtils.mkdir_p(log_dir)
    
    log_file = File.join(log_dir, "#{Hanami.env}.log")
    
    file_logger = Hanami::Logger.new(
      "data_analyzer_api",
      level: :info,
      stream: log_file
    )
    
    register "file_logger", file_logger
  end
end
