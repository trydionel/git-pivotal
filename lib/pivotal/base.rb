require 'rubygems'
require 'rest_client'
require 'nokogiri'

module Pivotal
  class Base
    include Pivotal::Associations
    
    attr_accessor :resource, :xml
    undef id
    
    def initialize(params = {})
      params.each do |key, value|
        send("#{key}=", value)
      end
    end    
    
    def xml
      @xml ||= resource.get
    end

    def parsed_resource
      @parsed_resource ||= Nokogiri::XML(xml)
    end
    
    def method_missing(method, *args)
      parsed_resource.css(method.to_s).text
    end
    
    class << self
      def xpath
        '//' + self.name.gsub(/.+\:\:/, '').downcase
      end
    end
    
  end
end