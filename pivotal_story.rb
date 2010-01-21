# =PivotalStory
# A naive way to allow easy access to pivotal tracker story details
class PivotalStory
  def initialize(story)
    @story = story
  end
  
  def id
    @story.at_css("id").text
  end
  
  def method_missing(method, *args)
    @story.css("#{method}").text
  end
end