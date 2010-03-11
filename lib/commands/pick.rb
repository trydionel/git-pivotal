require 'commands/base'

module Commands
  class Pick < Base
  
    def type
      raise Error "must define in subclass"
    end
    
    def plural_type
      raise Error "must define in subclass"
    end
  
    def branch_suffix
      raise Error "must define in subclass"
    end
    
    def run!
      super
    
      put "Retrieving latest #{plural_type} from Pivotal Tracker..."
      api = Pivotal::Api.new(:api_token => options[:api_token])

      project = api.projects.find(:id => options[:project_id])
      story = project.stories.find(:conditions => { :story_type => type, :current_state => :unstarted }, :limit => 1).first
    
      unless story
        put "No #{plural_type} available!"
        return 0
      end
    
      put "Story: #{story.name}"
      put "URL:   #{story.url}"

      put "Updating #{type} status in Pivotal Tracker..."
      if story.start!(:owned_by => options[:full_name])
    
        suffix = branch_suffix
        unless options[:quiet]
          put "Enter branch name (will be prepended by #{story.id}) [#{suffix}]: ", false
          suffix = input.gets.chomp
      
          suffix = "feature" if suffix == ""
        end

        branch = "#{story.id}-#{suffix}"
        if get("git branch").match(branch).nil?
          put "Creating #{branch} branch..."
          sys "git checkout -b #{branch}"
        end
    
        return 0
      else
        put "Unable to mark #{type} as started"
        
        return 1
      end
    end

  end
end