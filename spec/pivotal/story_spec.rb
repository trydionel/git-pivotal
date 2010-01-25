require 'spec_helper'

describe Pivotal::Story do

  before(:each) do
    @api = pivotal_api
    @project = Pivotal::Project.new :resource => @api.resource["projects"][1]
    @story = Pivotal::Story.new :resource => @project.resource["stories"][1]
  end
  
  it "should be connected to the story resource" do
    @story.resource.url.should == "https://www.pivotaltracker.com/services/v3/projects/1/stories/1"
  end
  
end