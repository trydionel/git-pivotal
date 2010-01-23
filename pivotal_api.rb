require 'rubygems'
require 'nokogiri'
require 'rest_client'

require 'pivotal_story'

class PivotalApi
  
  def initialize(options = {})
    url = "http://www.pivotaltracker.com/services/v2/projects/#{options[:project]}"
    @project = RestClient::Resource.new url, :headers => { 'X-TrackerToken' => options[:key], 'Content-Type' => 'application/xml' }
  end
  
  def stories(options = {})
    @stories ||= parsed_stories(options).map { |story| PivotalStory.new story, @project }
  end
  
private

  def raw_stories(options = {})
    begin
      @project["stories"]["?filter='current_state%3Aunstarted+story_type%3Afeature'"].get
    rescue
      ""
    end
  end
  
  def parsed_stories(options = {})
    Nokogiri::XML(raw_stories(options)).css("story")
  end

end