require 'spec_helper'

describe Pivotal::Associations do
  
  it "should load the #has_collection method into a class" do
    @base = Object
    @base.should_not respond_to(:has_collection)
    
    @base.send(:include, Pivotal::Associations)
    @base.should respond_to(:has_collection)
  end
  
end