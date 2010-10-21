$:.unshift('lib') unless $:.include?('lib')

require 'aruba'
require 'git-pivotal'
require 'pivotal-tracker'