# frozen_string_literal: true

require "dry/monads"

RSpec.configure do |config|

  config.include Dry::Monads[:result]
end
