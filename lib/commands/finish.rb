require 'commands/base'

module Commands
  class Finish < Base
  
    def run!
      super
      
      # clunky way to get branch name... need better method
      current_branch = get('git status | head -1').gsub(/^.+On branch /, '').chomp
      story_id = current_branch[/\d+/]
      unless story_id
        puts "Branch name must contain a Pivotal Tracker story id"
        return 1
      end

      api = Pivotal::Api.new(:api_token => options[:api_token])

      project = api.projects.find(:id => options[:project_id])
      story = project.stories.find(story_id)
      
      story.update_attributes(:current_state => :finished)
      
      return 0
    end

  end
end