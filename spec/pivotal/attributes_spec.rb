require 'spec_helper'

describe Pivotal::Attributes do
  
  it "should load the #has_attributes method onto a class" do
    @base = Class.new
    @base.should_not respond_to(:has_attributes)
    
    @base.send :include, Pivotal::Attributes
    @base.should respond_to(:has_attributes)
  end
  
  it "should add methods specified in #has_attributes to the object" do
    @base = Class.new
    @base.send :include, Pivotal::Attributes
    
    @base.new.should_not respond_to(:one)
    @base.has_attributes :one
    @base.new.should respond_to(:one)
  end
  
  it "should add the attributes specified in #has_attributes to the class #attributes list" do
    @base = Class.new
    @base.send :include, Pivotal::Attributes
    
    @base.attributes.should be_nil
    @base.has_attributes :one
    @base.attributes.should == ["one"]
  end
  
end