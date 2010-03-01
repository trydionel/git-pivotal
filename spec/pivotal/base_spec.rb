require 'spec_helper'
require 'nokogiri'

describe Pivotal::Base do
  
  before(:each) do
    @base = pivotal_api
    @response = mock("response")
    @response.stubs(:body => "<xml>Some XML String</xml>")
  end
  
  it "should expose a REST resource" do
    @base.resource.should be_a(RestClient::Resource)
  end
  
  it "should expose the resource's XML" do
    @base.resource.expects(:get).returns(@response)
    @base.xml.should be_a(String)
  end
  
  it "should expose the resource's XML parse tree" do
    @base.resource.expects(:get).returns(@response)
    @base.parsed_resource.should be_a(Nokogiri::XML::Document)
  end
  
  it "should present the class's item xpath" do
    @base.class.xpath.should == "//api"
  end
  
  it "should expose association methods" do
    @base.class.should include(Pivotal::Associations)
  end
  
  describe "updating the remote resource" do
    
    before(:each) do
      @xml = "<api><current_state>started</current_state></api>"
      @response.stubs(:code).returns(200)
      @response.stubs(:body).returns(@xml)
      
      @base.resource.expects(:put).with(@xml).yields(@response)
      @base.class.has_attributes :current_state
    end

    it "should be able to update the remote resource with a hash of string values" do
      @base.update_attributes(:current_state => "started")
    end
  
    it "should be able to update the remote resource with a hash of symbol values" do
      @base.update_attributes(:current_state => :started)
    end
    
    it "should not update attributes which don't exist on the remote model" do
      @base.update_attributes(:current_state => :started, :unknown_attribute => true)
    end
    
    it "should update the stored xml with the new remote model" do
      pending("not sure what changed here, but it needs to be fixed") do
        @base.resource.stubs(:get => @response)
        lambda {
          @base.update_attributes(:current_state => "started")
        }.should change(@base, :xml).to(@response.body)
      end
    end
    
    it "should return true if the response code is 200" do
      @base.update_attributes(:current_state => :started).should == true
    end
    
    it "should return false if the response code is not 200" do
      @response.stubs(:code).returns(422)
      @base.update_attributes(:current_state => :started).should == false
    end
    
  end
  
end