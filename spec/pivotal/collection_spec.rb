require 'spec_helper'

describe Pivotal::Collection do
  
  before(:each) do
    @api = pivotal_api
    response = mock("response")
    response.stubs(:body => "<project><id>1</id></project>")
    RestClient::Resource.any_instance.stubs(:get).returns(response)
  end
  
  it "should find a single item given an id" do
    @api.projects.find(1).should be_a(Pivotal::Project)
  end
  
  it "should find a collection of items giving a set of conditions" do
    @api.projects.find(:all).should be_a(Array)
    @api.projects.first.should be_a(Pivotal::Project)
  end
  
  it "should return the first item of a collection" do
    @api.projects.first.should be_a(Pivotal::Project)
  end
  
end