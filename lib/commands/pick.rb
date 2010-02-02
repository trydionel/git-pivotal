require 'commands/base'

module Commands
  class Pick < Base
  
    def run!
      unless options[:api_token] && options[:project_id]
        put "Pivotal Tracker API Token and Project ID are required"
        return 1
      end
    
      put "Retrieving latest stories from Pivotal Tracker..."
      api = Pivotal::Api.new(:api_token => options[:api_token])

      project = api.projects.find(:id => options[:project_id])
      story = project.stories.find(:conditions => { :story_type => :feature, :current_state => :unstarted }, :limit => 1).first
    
      unless story
        put "No stories available!"
        return 0
      end
    
      put "Story: #{story.name}"
      put "URL:   #{story.url}"

      suffix = "feature"
      unless options[:quiet]
        put "Enter branch name (will be prepended by #{story.id}) [feature]: ", false
        suffix = input.gets.chomp
      
        suffix = "feature" if suffix == ""
      end

      branch = "#{story.id}-#{suffix}"
      if get("git branch").match(branch).nil?
        put "Creating #{branch} branch..."
        sys "git checkout -b #{branch}"
      end
    
      put "Updating story status in Pivotal Tracker..."
      story.start!(:owned_by => options[:full_name])
    
      return 0
    end

  end
end