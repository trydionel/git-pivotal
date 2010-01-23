require 'mocha'
require 'commands/pick'
require 'pivotal/api'
require 'pivotal/story'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end