module Pivotal
  class Api < Base
  
    attr_accessor :api_token
    has_collection :projects, :of => Pivotal::Project
    
    def initialize(options = {})
      super(options)
      @api_url = "http://www.pivotaltracker.com/services/v3"
    end
  
    def resource
      @resource ||= RestClient::Resource.new @api_url, :headers => { 'X-TrackerToken' => api_token, 'Content-Type' => 'application/xml' }
    end
  
  end
end