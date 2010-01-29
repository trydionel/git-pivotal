require 'spec_helper'
require 'nokogiri'

describe Pivotal::Base do
  
  before(:each) do
    @base = pivotal_api
  end
  
  it "should expose a REST resource" do
    @base.resource.should be_a(RestClient::Resource)
  end
  
  it "should expose the resource's XML" do
    @base.resource.expects(:get).returns("")
    @base.xml.should be_a(String)
  end
  
  it "should expose the resource's XML parse tree" do
    @base.parsed_resource.should be_a(Nokogiri::XML::Document)
  end
  
  it "should forward undefined methods to the XML parse tree" do
    @base.should_not respond_to(:id)
    @base.id.should == "1"
  end
  
  it "should present the class's item xpath" do
    @base.class.xpath.should == "//api"
  end
  
  it "should expose association methods" do
    @base.class.should include(Pivotal::Associations)
  end
  
  describe "updating the remote resource" do
    
    before(:each) do
      @xml = "<story><current_state>started</current_state></story>"
      @base.resource.expects(:put).with(@xml).returns(@xml)
    end

    it "should be able to update the remote resource with a hash of string values" do
      @base.update_attributes(:current_state => "started")
    end
  
    it "should be able to update the remote resource with a hash of symbol values" do
      @base.update_attributes(:current_state => :started)
    end
    
    it "should not update attributes which don't exist on the remote model" do
      @base.update_attributes(:unknown_attribute => true)
    end
    
    it "should update the stored xml with the new remote model" do
      lambda {
        @base.update_attributes(:current_state => "started")
      }.should change(@base, :xml).to(@xml)
    end
    
  end
  
end