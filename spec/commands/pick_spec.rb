require 'spec_helper'
require 'commands/pick'

describe Pick do
  
  before(:each) do
    # stub out git config requests
    Pick.any_instance.expects(:get).times(3).with { |v| v =~ /git config/}.returns("")
  end
  
  it "should set the api key with the -k option" do
    @pick = Pick.new("-k", "1234")
    @pick.options[:api_token].should == "1234"
  end
  
  it "should set the api key with the --api-token= option" do
    @pick = Pick.new("--api-key=1234")
    @pick.options[:api_token].should == "1234"
  end
  
  it "should set the project id with the -p option" do
    @pick = Pick.new("-p", "1")
    @pick.options[:project_id].should == "1"
  end
  
  it "should set the project id with the --project-id= option" do
    @pick = Pick.new("--project-id=1")
    @pick.options[:project_id].should == "1"
  end
  
  it "should set the full name with the -n option" do
    @pick = Pick.new("-n", "Jeff Tucker")
    @pick.options[:full_name].should == "Jeff Tucker"
  end
  
  it "should set the full name with the --full-name= option" do
    @pick = Pick.new("--full-name=Jeff Tucker")
    @pick.options[:full_name].should == "Jeff Tucker"
  end
  
  it "should set the quiet flag with the -q option" do
    @pick = Pick.new("-q")
    @pick.options[:quiet].should be_true
  end
  
  it "should set the quiet flag with the --quiet option" do
    @pick = Pick.new("--quiet")
    @pick.options[:quiet].should be_true
  end
  
  it "should set the verbose flag with the -v option" do
    @pick = Pick.new("-v")
    @pick.options[:verbose].should be_true
  end
  
  it "should set the verbose flag with the --verbose option" do
    @pick = Pick.new("--verbose")
    @pick.options[:verbose].should be_true
  end
  
  it "should unset the verbose flag with the --no-verbose option" do
    @pick = Pick.new("--no-verbose")
    @pick.options[:verbose].should be_false
  end
  
end