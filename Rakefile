require 'rubygems'
require 'rake'
require 'spec/rake/spectask'

$LOAD_PATH.unshift('lib')

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "git-pivotal"
    gemspec.summary = "A collection of git utilities to ease integration with Pivotal Tracker"
    gemspec.description = "A collection of git utilities to ease integration with Pivotal Tracker"
    gemspec.email = "jeff@trydionel.com"
    gemspec.homepage = "http://github.com/trydionel/git-pivotal"
    gemspec.authors = ["Jeff Tucker", "Sam Stokes"]
    
    gemspec.add_dependency "nokogiri"
    gemspec.add_dependency "rest-client", "~>1.4.0"
    gemspec.add_dependency "builder"
    
    gemspec.add_development_dependency "rspec"
    gemspec.add_development_dependency "rcov"
    gemspec.add_development_dependency "mocha"
  end
  
  Jeweler::GemcutterTasks.new
rescue
  puts "Jeweler not available. Install it with: gem install jeweler"
end

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--color']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'gems']
end