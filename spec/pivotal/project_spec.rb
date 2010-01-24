require 'spec_helper'

describe Pivotal::Project do
  
  before(:each) do
    @api = pivotal_api
    @project = Pivotal::Project.new :resource => @api.resource["projects"][1]
  end
  
  it "should be connected to the project resource" do
    @project.resource.url.should == "http://www.pivotaltracker.com/services/v3/projects/1"
  end
  
  it "should have a collection of stories" do
    @project.stories.should be_a(Pivotal::Collection)
    @project.stories.component_class.should == Pivotal::Story
  end
  
end