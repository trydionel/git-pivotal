require 'commands/base'

module Commands
  class Pick < Base
  
    def type
      raise Error("must define in subclass")
    end
    
    def plural_type
      raise Error("must define in subclass")
    end
  
    def branch_suffix
      raise Error("must define in subclass")
    end
    
    def run!
      super

      msg = "Retrieving latest #{plural_type} from Pivotal Tracker"
      if options[:only_mine]
        msg += " for #{options[:full_name]}"
      end
      put "#{msg}..."
      
      unless story
        put "No #{plural_type} available!"
        return 0
      end
    
      put "Story: #{story.name}"
      put "URL:   #{story.url}"

      put "Updating #{type} status in Pivotal Tracker..."
      if story.start!(:owned_by => options[:full_name])
    
        unless options[:quiet]
          put "Enter branch name (will be prepended by #{story.id}) [#{branch_suffix}]: ", false
          suffix = input.gets.chomp

          suffix = branch_suffix if suffix == ""
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

  protected

    def story
      return @story if @story
      
      conditions = { :story_type => type, :current_state => :unstarted }
      conditions[:owned_by] = options[:full_name] if options[:only_mine]
      @story = project.stories.find(:conditions => conditions, :limit => 1).first
    end
  end
end
