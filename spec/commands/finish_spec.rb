require 'commands/finish'
require 'spec_helper'

describe Commands::Finish do

  def mock_projects
    if @mock_projects.nil?
      @mock_projects = mock("mock project list")
      @mock_projects.stubs(:find).with(:id => mock_project_id).returns(mock_project)
    end
    @mock_projects
  end

  def mock_project_id
    @mock_project_id ||= '4321'
  end

  def mock_project
    if @mock_project.nil?
      @mock_project = mock("mock project")
      @mock_project.stubs(:stories).returns(mock_stories)
    end
    @mock_project
  end

  def mock_stories
    if @mock_stories.nil?
      @mock_stories = mock("mock story list")
      @mock_stories.stubs(:find).with(:id => mock_story_id).returns(mock_story)
    end
    @mock_stories
  end

  def mock_story_id
    @mock_story_id ||= '1234'
  end

  def mock_story
    if @mock_story.nil?
      @mock_story = mock("mock story")
    end
    @mock_story
  end

  before(:each) do
    # stub out git config requests
    Commands::Finish.any_instance.stubs(:get).with { |v| v =~ /git config/ }.returns("")

    Pivotal::Api.any_instance.stubs(:projects).returns(mock_projects)

    @finish = Commands::Finish.new(nil, nil, "-p", mock_project_id)
    @finish.stubs(:sys)
    @finish.stubs(:put)
  end

  context "where the branch name does not contain a valid story id" do
    before(:each) do
      # stub out git status request to identify the branch
      branch_name = "invalid-branch-name-without-story-id"
      Commands::Finish.any_instance.stubs(:get).with { |v| v =~ /git status/ }.returns("# On branch #{branch_name}")
    end

    it "should return an exit status of one" do
      @finish.run!.should == 1
    end

    it "should print an error message" do
      @finish.expects(:put).with("Branch name must contain a Pivotal Tracker story id").once
      @finish.run!
    end
  end

  context "where the branch name does contain a valid story id" do
    def branch_name
      "#{mock_story_id}-feature-branch-name"
    end

    before(:each) do
      # stub out git status request to identify the branch
      Commands::Finish.any_instance.stubs(:get).with { |v| v =~ /git status/ }.returns("# On branch #{branch_name}")
    end

    it "should attempt to update the story status to the stories finished_state" do
      mock_story.stubs(:finished_state).returns(:finished)
      mock_story.expects(:update_attributes).with(:current_state => :finished)
      @finish.run!
    end

    context "and the story is successfully marked as finished in PT" do
      before(:each) do
        mock_story.stubs(:finished_state).returns(:finished)
        mock_story.stubs(:update_attributes).with(:current_state => :finished).returns(true)
      end

      it "should succeed with an exist status of zero" do
        @finish.run!.should == 0
      end

      it "should checkout the developer's integration branch" do
        @finish.expects(:sys).with("git checkout master")
        @finish.run!
      end

      it "should merge in the story branch" do
        @finish.expects(:sys).with("git merge --no-ff #{branch_name}")
        @finish.run!
      end

      it "should remove the story branch" do
        @finish.expects(:sys).with("git branch -d #{branch_name}")
        @finish.run!
      end
    end

    context "and the story fails to be marked as finished in PT" do
      before(:each) do
        mock_story.stubs(:finished_state).returns(:finished)
        mock_story.stubs(:update_attributes).with(:current_state => :finished).returns(false)
      end

      it "should fail with an exist status of one" do
        @finish.run!.should == 1
      end

      it "should print an error message" do
        @finish.expects(:put).with("Unable to mark Story #{mock_story_id} as finished").once
        @finish.run!
      end
    end
  end
end
