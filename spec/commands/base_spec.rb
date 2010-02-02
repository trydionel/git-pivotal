require 'spec_helper'
require 'commands/base'

describe Commands::Base do
  
  before(:each) do
    @input = mock('input')
    @output = mock('output')
    
    # stub out git config requests
    Commands::Base.any_instance.stubs(:get).with { |v| v =~ /git config/ }.returns("")
  end
  
  it "should set the api key with the -k option" do
    @pick = Commands::Base.new(@input, @output,"-k", "1234")
    @pick.options[:api_token].should == "1234"
  end
  
  it "should set the api key with the --api-token= option" do
    @pick = Commands::Base.new(@input, @output,"--api-key=1234")
    @pick.options[:api_token].should == "1234"
  end
  
  it "should set the project id with the -p option" do
    @pick = Commands::Base.new(@input, @output,"-p", "1")
    @pick.options[:project_id].should == "1"
  end
  
  it "should set the project id with the --project-id= option" do
    @pick = Commands::Base.new(@input, @output,"--project-id=1")
    @pick.options[:project_id].should == "1"
  end
  
  it "should set the full name with the -n option" do
    @pick = Commands::Base.new(@input, @output,"-n", "Jeff Tucker")
    @pick.options[:full_name].should == "Jeff Tucker"
  end
  
  it "should set the full name with the --full-name= option" do
    @pick = Commands::Base.new(@input, @output,"--full-name=Jeff Tucker")
    @pick.options[:full_name].should == "Jeff Tucker"
  end
  
  it "should set the quiet flag with the -q option" do
    @pick = Commands::Base.new(@input, @output,"-q")
    @pick.options[:quiet].should be_true
  end
  
  it "should set the quiet flag with the --quiet option" do
    @pick = Commands::Base.new(@input, @output,"--quiet")
    @pick.options[:quiet].should be_true
  end
  
  it "should set the verbose flag with the -v option" do
    @pick = Commands::Base.new(@input, @output,"-v")
    @pick.options[:verbose].should be_true
  end
  
  it "should set the verbose flag with the --verbose option" do
    @pick = Commands::Base.new(@input, @output,"--verbose")
    @pick.options[:verbose].should be_true
  end
  
  it "should unset the verbose flag with the --no-verbose option" do
    @pick = Commands::Base.new(@input, @output,"--no-verbose")
    @pick.options[:verbose].should be_false
  end
  
end