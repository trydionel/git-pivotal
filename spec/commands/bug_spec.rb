require 'spec_helper'

describe Commands::Bug do

  before(:each) do
    # stub out git config requests
    Commands::Bug.any_instance.stubs(:get).with { |v| v =~ /git config/ }.returns("")

    @bug = Commands::Bug.new
  end
  
  it "should specify its story type" do
    @bug.type.should == "bug"
  end
  
  it "should specify a plural for its story types" do
    @bug.plural_type.should == "bugs"
  end
  
  it "should specify its branch suffix" do
    @bug.branch_suffix.should == "bugfix"
  end
  
end