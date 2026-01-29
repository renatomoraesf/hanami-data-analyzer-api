# config/boot.rb
require "bundler/setup"
require "hanami/setup"
require_relative "app"

Hanami.boot # Isso garante que todas as chaves, incluindo rack.monitor, sejam registradas