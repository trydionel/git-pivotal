# =PivotalStory
# A naive way to allow easy access to pivotal tracker story details
class PivotalStory
  def initialize(story, project)
    @story, @project = story, project
  end
  
  def start!
    begin
      @project["stories"][id].put "<story><current_state>started</current_state></story>"
    rescue RestClient::RequestFailed => res
      puts res.inspect
    end
  end
  
  def id
    @story.at_css("id").text
  end
  
  def method_missing(method, *args)
    @story.css("#{method}").text
  end
end