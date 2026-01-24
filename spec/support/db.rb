# frozen_string_literal: true

RSpec.configure do |config|
  config.define_derived_metadata(type: :feature) do |metadata|
    metadata[:db] = true
  end
end
