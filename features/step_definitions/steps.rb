PIVOTAL_TEST_PROJECT = 52815
PIVOTAL_TEST_ID = 5799841

Given /^I have a Pivotal Tracker ([^\"]*)$/ do |type|
  create_story(type)
end

When /^I execute git ([^\" ]*)$/ do |method|
  execute_method(method)
end

When /^I execute git ([^\"]*) with:$/ do |method, table|
  options = table.hashes.inject([]) { |acc, h| acc << [h["key"], h["value"]] }.flatten
  execute_method(method, options)
end

Then /^I should see "([^\"]*)"$/ do |text|
  @output_buffer.string.should =~ Regexp.new(text)
end

Then /^I should be on the "([^"]*)" branch$/ do |branch|
  current_branch.should == branch
end

def create_story(type)
  PivotalTracker::Client.token = "10bfe281783e2bdc2d6592c0ea21e8d5"
  project = PivotalTracker::Project.find(PIVOTAL_TEST_PROJECT)
  @story  = project.stories.find(PIVOTAL_TEST_ID)
  
  @story.update(:story_type    => type.to_s,
                :current_state => "unstarted",
                :estimate      => (type.to_s == "feature" ? 1 : nil))
  sleep(3) # let the data propogate
end

def execute_method(method, args = [])
  default_response = StringIO.new("\n")
  command = Commands.const_get(method.capitalize).new(default_response, @output_buffer, *args)
  command.run!
end

def current_branch
  `git symbolic-ref HEAD`.chomp.split('/').last
end