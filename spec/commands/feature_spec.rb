require 'spec_helper'

describe Commands::Feature do

  before(:each) do
    # stub out git config requests
    Commands::Feature.any_instance.stubs(:get).with { |v| v =~ /git config/ }.returns("")

    @feature = Commands::Feature.new
  end
  
  it "should specify its story type" do
    @feature.type.should == "feature"
  end
  
  it "should specify a plural for its story types" do
    @feature.plural_type.should == "features"
  end
  
  it "should specify its branch suffix" do
    @feature.branch_suffix.should == "feature"
  end
  
end