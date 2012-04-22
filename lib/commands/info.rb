require 'commands/base'

module Commands
  class Info < Base

    def run!
      super

      unless story_id
        put "Branch name must contain a Pivotal Tracker story id"
        return 1
      end
      
      unless story_id > 0
        put "Branch name must contain a Pivotal Tracker story id"
        return 1
      end

      put "Story:         #{story.name}"
      put "URL:           #{story.url}"
      put "Description:   #{story.description}"

      return 0
    end

  protected

    def story_id
      current_branch[/\d+/].to_i
    end

    def story
      @story ||= project.stories.find(story_id)
    end
  end
end
