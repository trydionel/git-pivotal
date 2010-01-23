require 'spec_helper'
require 'nokogiri'

describe Pivotal::Story do
  before(:each) do
    @xml = Nokogiri::XML("<story><id>1</id><current_state>unstarted</current_state></story>")
    @project = Pivotal::Api.new
    @story = Pivotal::Story.new @xml, @project
  end
  
  it "should expose the Pivotal Tracker story id" do
    @story.id.should == "1"
  end
  
  it "should delegate all other methods to the xml xpath" do
    @story.should_not respond_to("current_state")
    @story.current_state.should == "unstarted"
  end
  
  it "should be able to mark a story as 'started'" do
    
  end
end