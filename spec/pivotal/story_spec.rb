require 'spec_helper'

describe Pivotal::Story do

  def story_type(type = "feature")
    Factory(:story, :story_type => type)
  end
  
  before(:each) do
    @story = Pivotal::Story.new :resource => pivotal_api.resource["projects"][1]["stories"][1]
    @response = mock("response")
    @response.stubs(:body => "")
  end
  
  it "should be connected to the story resource" do
    @story.resource.url.should == "https://www.pivotaltracker.com/services/v3/projects/1/stories/1"
  end
  
  [:id, :story_type, :url, :estimate, :current_state,
     :description, :name, :requested_by, :owned_by,
     :created_at, :accepted_at, :labels].map(&:to_s).each do |method|
    it "should have an accessor method for #{method}" do
      @story.methods.should include(method)
    end
    
    it "should include #{method} in the list of valid attributes" do
      @story.class.attributes.should include(method)
    end
    
    it "should return the proper value when #{method} is called" do
      @story.xml = Factory(:story, method.to_sym => "Test Result")
      @story.send(method).should == "Test Result"
    end
  end
  
  it "should specify whether the story is a feature" do
    @story.xml = story_type "feature"

    @story.should be_a_feature
    @story.should_not be_a_bug
    @story.should_not be_a_chore
    @story.should_not be_a_release
  end
  
  it "should specify whether the story is a bug" do
    @story.xml = story_type "bug"

    @story.should_not be_a_feature
    @story.should be_a_bug
    @story.should_not be_a_chore
    @story.should_not be_a_release
  end
  
  it "should specify whether the story is a chore" do
    @story.xml = story_type "chore"

    @story.should_not be_a_feature
    @story.should_not be_a_bug
    @story.should be_a_chore
    @story.should_not be_a_release
  end
  
  it "should specify whether the story is a release" do
    @story.xml = story_type "release"

    @story.should_not be_a_feature
    @story.should_not be_a_bug
    @story.should_not be_a_chore
    @story.should be_a_release
  end
  
  it "should be able to mark the story as started" do
    @story.resource.stubs(:get => @response)

    @xpath = "//current_state = 'started'"
    @story.resource.expects(:put).with { |xml| Nokogiri::XML(xml).xpath(@xpath) }
    @story.start!
  end
  
  it "should be able to update other attributes when marking the story as started" do
    @story.resource.stubs(:get => @response)

    # Check the XML contains the right options.
    # Can't just check the XML string, because the elements may be in a
    # different order (because it's built from a hash).
    @xpath = "//current_state = 'started' and //owned_by = 'Jeff Tucker'"
    @story.resource.expects(:put).with {|xml| Nokogiri.XML(xml).xpath(@xpath) }
    @story.start!(:owned_by => "Jeff Tucker")
  end
  
  it "should return false if attempting to start an unestimated feature story" do
    # bad_response = mock("Response")
    # bad_response.stubs(:code).returns(422)
    # RestClient::Resource.any_instance.stubs(:put).yields(bad_response)
    
    @story.xml = Factory(:story, :story_type => :feature, :estimate => :unestimated)
    @story.start!.should be_false
  end

  it "should return a finished state of accepted for a chore" do
    @story.xml = story_type "chore"
    @story.finished_state.should == :accepted
  end

  ["feature", "release", "bug"].each do |type|
    it "should return a finished state of finished for a #{type}" do
      @story.xml = story_type type
      @story.finished_state.should == :finished
    end
  end

  
end
