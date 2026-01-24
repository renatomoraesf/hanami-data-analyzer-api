# frozen_string_literal: true

require "rack/test"

RSpec.shared_context "with Rack::Test" do

  let(:app) { Hanami.app }
end

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :request
  config.include_context "with Rack::Test", type: :request
end
