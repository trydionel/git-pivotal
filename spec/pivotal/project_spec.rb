require 'spec_helper'

describe Pivotal::Project do
  
  before(:each) do
    @api = pivotal_api
    @project = Pivotal::Project.new :resource => @api.resource["projects"][1]
  end
  
  it "should be connected to the project resource" do
    @project.resource.url.should == "https://www.pivotaltracker.com/services/v3/projects/1"
  end
  
  it "should have a collection of stories" do
    @project.stories.should be_a(Pivotal::Collection)
    @project.stories.component_class.should == Pivotal::Story
  end
  
  [:id, :name, :iteration_length, :week_start_day,
   :point_scale, :account, :velocity_scheme,
   :current_velocity, :initial_velocity,
   :number_of_iterations_to_show, :labels,
   :allow_attachments, :public, :use_https,
   :bugs_and_chores_are_estimatable, :commit_mode,
   :last_activity_at, :memberships, :integrations].map(&:to_s).each do |method|
     it "should have an accessor method for #{method}" do
       @project.methods.should include(method)
     end

     it "should include #{method} in the list of valid attributes" do
       @project.class.attributes.should include(method)
     end    
  end
  
end