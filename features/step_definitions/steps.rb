PIVOTAL_TEST_PROJECT = 52815
PIVOTAL_TEST_ID = 5799841
STORY_TYPE = /unscheduled|unstarted|started|finished|delivered|accepted|rejected/

Given /^I have a(?:n)? (#{STORY_TYPE})?\s?Pivotal Tracker ([^\"]*)$/ do |status, type|
  create_story(type, status)
end

Given /^I am on the "([^"]*)" branch$/ do |branch|
  `git checkout -b #{branch} > /dev/null 2>&1`
end

Given /^I have a "([^"]*)" branch$/ do |branch|
  `git branch #{branch} > /dev/null 2>&1`
end

Then /^I should be on the "([^"]*)" branch$/ do |branch|
  current_branch.should == branch
end

def create_story(type, status = "unstarted")
  PivotalTracker::Client.token = "10bfe281783e2bdc2d6592c0ea21e8d5"
  project = PivotalTracker::Project.find(PIVOTAL_TEST_PROJECT)
  @story  = project.stories.find(PIVOTAL_TEST_ID)
  
  @story.update(:story_type    => type.to_s,
                :current_state => status,
                :estimate      => (type.to_s == "feature" ? 1 : nil))
  sleep(4) # let the data propagate
end

def execute_method(method, args = [])
  default_response = StringIO.new("\n")
  command = Commands.const_get(method.capitalize).new(default_response, @output_buffer, *args)
  command.run!
end

def current_branch
  `git symbolic-ref HEAD`.chomp.split('/').last
end