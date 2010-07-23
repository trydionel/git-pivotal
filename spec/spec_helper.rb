require 'rubygems'
require 'mocha'
require 'builder'
require 'pivotal'
require File.join(File.dirname(__FILE__), 'factories')

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

def stub_connection_to_pivotal
  RestClient::Resource.any_instance.stubs(:get).returns("")
end