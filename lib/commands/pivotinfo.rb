require 'commands/base'

module Commands
  class Pivotinfo < Base
  
    def run!
      super
      
      unless story_id
        put "Branch name must contain a Pivotal Tracker story id"
        return 1
      end

      put "Story:         #{story.name}"
      put "URL:           #{story.url}"
      put "Description:   #{story.description}"

      return 0
    end

  protected
  
    def current_branch
      @current_branch ||= get('git symbolic-ref HEAD').chomp.split('/').last
    end

    def story_id
      current_branch[/\d+/].to_i
    end

    def story
      @story ||= project.stories.find(story_id)
    end
  end
end
