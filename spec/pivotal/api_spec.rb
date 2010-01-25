require 'spec_helper'

describe Pivotal::Api do
  
  before(:each) do
    @api = pivotal_api
  end
  
  it "should connect to Pivotal Tracker's API" do
    @api.resource.url.should == "https://www.pivotaltracker.com/services/v3"
  end
  
  it "should have a collection of projects" do
    @api.projects.should be_a(Pivotal::Collection)
    @api.projects.component_class.should == Pivotal::Project
  end

end