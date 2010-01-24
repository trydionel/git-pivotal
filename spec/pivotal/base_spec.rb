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
  
end