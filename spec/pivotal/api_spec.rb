require 'spec_helper'

describe Pivotal::Api do
  before(:each) do
    @api = Pivotal::Api.new :api_token => 1, :project_id => 1
  end
  
  it "should expose a Pivotal Tracker project" do
    @api.project.should be_a(RestClient::Resource)
  end
  
  it "should expose a collection of Pivotal Tracker stories" do
    @api.stubs(:raw_stories).returns("<story></story>")
    @api.stories.should be_a(Array)
    @api.stories.first.should be_a(Pivotal::Story)
  end
  
  it "should collect only unstarted feature stories" do
    pending
  end
  
end