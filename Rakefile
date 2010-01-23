require 'rake'

$LOAD_PATH.unshift('lib')

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "git-pivotal"
    gemspec.summary = "A collection of git utilities to ease integration with Pivotal Tracker"
    gemspec.description = "A collection of git utilities to ease integration with Pivotal Tracker"
    gemspec.email = "jeff@trydionel.com"
    gemspec.homepage = "http://github.com/trydionel/git-pivotal"
    gemspec.authors = ["Jeff Tucker"]
    
    gemspec.executables = ["bin/git-pick"]
    
    gemspec.add_dependency "nokogiri"
    gemspec.add_dependency "rest_client"
    
    gemspec.add_development_dependency "rspec"
  end
  
  Jeweler::GemcutterTasks.new
rescue
  puts "Jeweler not available. Install it with: gem install jeweler"
end