#!/usr/bin/env ruby
require "hanami"
require_relative "config/app"

# Inicie o servidor em modo simples
puts "Iniciando servidor de teste..."

# Configure o app
app = DataAnalyzerApi::App.new

# Crie um servidor Rack simples
require "rack"
require "rackup"

# Rota simples para teste
simple_app = ->(env) do
  req = Rack::Request.new(env)
  
  case req.path
  when "/"
    [200, {"Content-Type" => "application/json"}, ['{"status":"ok","api":"Data Analyzer"}']]
  when "/health"
    [200, {"Content-Type" => "application/json"}, ['{"status":"healthy"}']]
  else
    [404, {"Content-Type" => "application/json"}, ['{"error":"Not found"}']]
  end
end

puts "Servidor pronto em http://localhost:9292"
puts "Pressione Ctrl+C para parar"

# Use o handler padrão
Rackup::Handler.default.run(simple_app, Port: 9292)
