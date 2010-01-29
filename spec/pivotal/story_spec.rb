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
  
  it "should be able to mark the story as started" do
    @xml = "<story><current_state>started</current_state></story>"
    @story.resource.expects(:put).with(@xml)

    @story.start!
  end
  
  it "should be able to update other attributes when marking the story as started" do
    @xml = "<story><current_state>started</current_state><owned_by>Jeff Tucker</owned_by></story>"
    @story.resource.expects(:put).with(@xml)

    @story.start!(:owned_by => "Jeff Tucker")
  end
  
end