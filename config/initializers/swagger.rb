# config/initializers/swagger.rb
require 'rswag'

Hanami.configure do

  mount Api::SwaggerDocs, at: '/api-docs'
end