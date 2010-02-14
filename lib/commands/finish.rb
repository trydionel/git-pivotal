require 'commands/base'

module Commands
  class Finish < Base
  
    def run!
      super
      
      # clunky way to get branch name... need better method
      current_branch = get('git status | head -1').gsub(/^.+On branch /, '').chomp
      story_id = current_branch[/\d+/]
      unless story_id
        put "Branch name must contain a Pivotal Tracker story id"
        return 1
      end

      api = Pivotal::Api.new(:api_token => options[:api_token])
      project = api.projects.find(:id => options[:project_id])
      story = project.stories.find(:id => story_id)
      
      put "Marking Story #{story_id} as finished..."
      story.update_attributes(:current_state => :finished)
      
      target_branch = "develop"
      put "Merging #{current_branch} into #{target_branch}"
      sys "git checkout #{target_branch}"
      sys "git merge --no-ff #{current_branch}"
      
      put "Removing #{current_branch} branch"
      sys "git branch -d #{current_branch}"
      
      return 0
    end

  end
end