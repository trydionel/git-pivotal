require 'commands/base'

module Commands
  class Story < Base

    def run!
      response = super
      return response if response > 0

      story   = find_story
      command = command_class(story.story_type).new(@input, @output, @options)
      command.story = story
      return command.run!

    rescue
      put "Unable to find story!"
      exit 1
    end

  private

    def find_story
      conditions = {
        :story_type => %w[feature bug chore],
        :current_state => "unstarted",
        :limit => 1,
        :offset => 0
      }
      conditions[:owned_by] = options[:full_name] if options[:only_mine]

      project.stories.all(conditions).first
    end

    def command_class(type)
      first, rest = type.split('', 2)
      type = "#{first.upcase}#{rest}"

      Commands.const_get(type)
    end
  end
end
