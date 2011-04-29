require 'commands/base'

module Commands
  class Story < Base

    def run!
      response = super
      return response if response > 0

      story   = find_story
      command = command_class(story.type).new
      command.story = story
      return command.run!

    rescue
      put "Unable to find story!"
      put "Are you sure the given story ID exists?" if story_id
      exit 1
    end

  private

    def find_story(story_id = nil)
      conditions = {
        :story_type => "feature,bug,chore",
        :current_state => "unstarted",
        :limit => 1,
        :offset => 0
      }
      conditions[:story_id] = story_id if story_id
      conditions[:owned_by] = options[:full_name] if options[:only_mine]

      project.stories.all(conditions).first
    end

    def command_class(type)
      first, rest = type.split('', 2)
      type = "#{first.upcase}#{rest}"

      Commands.get_const(type)
    end
  end
end
