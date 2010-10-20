require 'spec_helper'

describe Commands::Chore do

  before(:each) do
    # stub out git config requests
    Commands::Chore.any_instance.stubs(:get).with { |v| v =~ /git config/ }.returns("")

    @chore = Commands::Chore.new
  end
  
  it "should specify its story type" do
    @chore.type.should == "chore"
  end
  
  it "should specify a plural for its story types" do
    @chore.plural_type.should == "chores"
  end
  
  it "should specify its branch suffix" do
    @chore.branch_suffix.should == "chore"
  end
  
end