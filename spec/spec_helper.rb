Dir[File.expand_path('support', File.dirname(__FILE__)) + "/**/*.rb"].each { |f| require f }

begin
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end
rescue LoadError
end

require 'securely_hashed_attributes'
require 'with_model'

RSpec.configure do |config|
  config.extend WithModel
end