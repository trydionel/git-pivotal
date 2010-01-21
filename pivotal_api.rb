require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'cgi'

require 'pivotal_story'

class PivotalApi
  
  def initialize(options = {})
    @key      = options[:key]
    @project  = options[:project]
    @base_url = "http://www.pivotaltracker.com/services/v2/projects/#{@project}"
  end
  
  def stories(options = {})
    return @stories unless @stories.nil? || options[:force]
    options[:filter] ||= "current_state:unstarted"
    
    url = [
      "#{@base_url}/stories?filter=#{CGI.escape(options[:filter])}",
      { "X-TrackerToken" => @key }
    ]
    
    @stories = Nokogiri::XML(open(*url)).xpath("//story").map { |story| PivotalStory.new story }
  end

end