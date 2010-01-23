require 'rubygems'
require 'nokogiri'
require 'rest_client'
require 'cgi'

module Pivotal
  class Api
    
    attr_accessor :api_token, :project_id, :url
    
    def initialize(options = {})
      options.each do |key, value|
        send("#{key}=", value)
      end
    end
  
    def url
      @url ||= "http://www.pivotaltracker.com/services/v2/projects/#{project_id}"
    end
  
    def project
      @project ||= RestClient::Resource.new url, :headers => { 'X-TrackerToken' => api_token, 'Content-Type' => 'application/xml' }
    end

    def stories
      @stories ||= parsed_stories.map { |story| Pivotal::Story.new story, project }
    end
  
  private
  
    def filters
      @filters ||= "?filter='#{CGI::escape("current_state:unstarted story_type:feature")}'"
    end
  
    def raw_stories
      begin
        project["stories"][filters].get
      rescue
        ""
      end
    end
  
    def parsed_stories
      Nokogiri::XML(raw_stories).css("story")
    end

  end
end