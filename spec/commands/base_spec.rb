require 'spec_helper'

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

  it "should set the integration branch with the -b option" do
    @pick = Commands::Base.new(@input, @output, "-b", "integration")
    @pick.send(:integration_branch).should == "integration"
  end

  it "should set the integration branch from git config" do
    Commands::Base.any_instance.stubs(:get).with("git config --get pivotal.integration-branch").returns("chickens")
    @pick = Commands::Base.new
    @pick.send(:integration_branch).should == "chickens"
  end

  it "should set the integration branch with the --integration-branch= option" do
    @pick = Commands::Base.new(@input, @output, "--integration-branch=integration")
    @pick.send(:integration_branch).should == "integration"
  end

  it "should default the integration branch to master if none is specified" do
    @pick = Commands::Base.new
    @pick.send(:integration_branch).should == "master"
  end

  it "should print a message if the API token is missing" do
    @output.expects(:print).with("Pivotal Tracker API Token and Project ID are required\n")

    @pick = Commands::Base.new(@input, @output, "-p", "1")
    @pick.run!
  end
  
  it "should print a message if the project ID is missing" do
    @output.expects(:print).with("Pivotal Tracker API Token and Project ID are required\n")

    @pick = Commands::Base.new(@input, @output, "-k", "1")
    @pick.run!    
  end
  
  it "should set the append name flag with the -a option" do
    @pick = Commands::Base.new(@input, @output,"-a")
    @pick.options[:append_name].should be_true
  end

  it "should set the append name flag from git config" do
    Commands::Base.any_instance.stubs(:get).with("git config --get pivotal.append-name").returns("true")
    @pick = Commands::Base.new
    @pick.options[:append_name].should be_true
  end

  it "should set the append name flag with the --append-name" do
    @pick = Commands::Base.new(@input, @output, "--append-name")
    @pick.options[:append_name].should be_true
  end

  it "should default the append name flag if none is specified" do
    @pick = Commands::Base.new
    @pick.options[:append_name].should be_false
  end
end