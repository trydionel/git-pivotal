require 'commands/base'

module Commands
  class Info < Base

    def run!
      super

      unless story_id
        put "Branch name must contain a Pivotal Tracker story id"
        return 1
      end

      put "Story:         #{story.name}"
      put "URL:           #{story.url}"
      put "Description:   #{story.description}"

      fetched_stories = stories

      if fetched_stories.size > 0
        puts
        put "Upcoming stories:"

        fetched_stories.each do |s|
          put "  #{s.story_type[0].upcase!}#{rounded_text s.estimate}: #{s.name}"
          put "     #{s.url}\tby #{s.requested_by}\t#{rounded_text s.labels}"
          puts "\t\t#{s.description}" if s.description != '' && options[:upcoming_with_desc]
          puts
        end
      end

      return 0
    end

  protected

    def story_id
      current_branch[/\d+/].to_i
    end

    def story
      @story ||= project.stories.find(story_id)
    end

    def stories
      limit = options[:upcoming] || options[:upcoming_with_desc] || 0
      return [] if limit == 0
      conditions = {:current_state => "unstarted", :limit => limit, :offset => 0}
      conditions[:owned_by] = options[:full_name] if options[:only_mine]
      @story = project.stories.all(conditions)
    end

    def rounded_text(text)
      '(' + text.to_s + ')' if text
    end

  end
end
