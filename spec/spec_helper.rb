require 'rubygems'
require 'mocha'
require 'builder'
require 'pivotal'
require 'commands/pick'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

def demo_xml
  Builder::XmlMarkup.new.project do |project|
    project.id 1
  end
end

def stub_connection_to_pivotal
  RestClient::Resource.any_instance.stubs(:get).returns(demo_xml)
end

def pivotal_api
  stub_connection_to_pivotal
  Pivotal::Api.new :api_token => 1
end