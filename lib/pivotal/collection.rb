require 'cgi'

module Pivotal
  class Collection
    
    attr_accessor :resource, :component_class
    
    def initialize(resource, component_class)
      @resource, @component_class = resource, component_class
    end
    
    # Param queries will break our REST structure,
    # so if we find an :id parameter, accept it and
    # ignore all other params.
    def find(*args)
      conditions = args.last.is_a?(Hash) ? args.pop : {}
      finder = args.first
      
      return item(conditions[:id]) if conditions[:id]
      return item(finder) if finder.is_a?(Numeric)
      
      all(conditions)
    end
    
    def first
      all.first
    end
    
  private
  
    def item(id)
      component_class.new :resource => resource[id]
    end
  
    def filters(conditions = {})
      return "" if conditions.empty?
      
      condition_string = conditions.map { |k,v| "#{k}=#{v}" }.join " "
      "?filter='#{CGI::escape(condition_string)}'"
    end
    
    def build_collection_from_xml(xml = "")
      Nokogiri::XML(xml).xpath(component_class.xpath).map do |item|
        item_id = item.xpath("//id").text
        component_class.new :resource => resource[item_id], :xml => item.to_xml
      end
    end
    
    def all(conditions = {})
      build_collection_from_xml resource[filters(conditions)].get
    end
    
  end
end