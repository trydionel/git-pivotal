require 'rubygems'
gem 'rest-client', '~>1.4.0'
require 'rest_client'
require 'nokogiri'
require 'builder'

module Pivotal
  class Base
    include Pivotal::Associations
    include Pivotal::Attributes
    
    attr_accessor :resource, :xml
    
    def initialize(params = {})
      params.each do |key, value|
        send("#{key}=", value)
      end
    end    
    
    def xml
      @xml ||= resource.get.body
    end

    def parsed_resource
      @parsed_resource ||= Nokogiri::XML(xml)
    end
    
    def update_attributes(options = {})
      begin
        resource.put generate_xml(options) do |response|
          if response.code == 200
            @xml = response.body
            return true
          else
            return false
          end
        end
      rescue RestClient::Exception
        return false
      end
    end
    
    class << self
      def name_as_xml_attribute
        self.name.gsub(/.+\:\:/, '').downcase
      end
      
      def xpath
        '//' + self.name_as_xml_attribute
      end
    end
    
  private
  
    def generate_xml(options = {})
      builder = Builder::XmlMarkup.new
      builder.__send__ self.class.name_as_xml_attribute do
        allowed_keys(options).each do |key, value|
          builder.__send__(key, value.to_s)
        end
      end
      
      builder.target!
    end
    
    def allowed_keys(options = {})
      options.reject do |key, _|
        !self.class.attributes.include? key.to_s
      end
    end
    
  end
end