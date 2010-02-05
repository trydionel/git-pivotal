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
      params = args.last.is_a?(Hash) ? args.pop : {}
      finder = args.first
      
      return item(params[:id]) if params[:id]
      return item(finder) if finder.is_a?(Numeric)
      
      all(params)
    end
    
    def first
      all.first
    end
    
  private
  
    def item(id)
      component_class.new :resource => resource[id]
    end
  
    def filters(params = {})
      return "" if params.empty?

      param_url = []
      if params[:conditions]
        condition_string = params[:conditions].map { |k,v| "#{k}:#{v}" }.join " "
        param_url << "filter=#{CGI::escape(condition_string)}"
      end
      
      if params[:limit]
        param_url << "limit=#{params[:limit]}&offset=#{params[:offset]||0}"
      end
      
      "?" + param_url.join("&")
    end
    
    def build_collection_from_xml(xml = "")
      Nokogiri::XML(xml).xpath(component_class.xpath).map do |item|
        item_id = item.xpath("id").text
        component_class.new :resource => resource[item_id], :xml => item.to_xml
      end
    end
    
    def all(params = {})
      build_collection_from_xml resource[filters(params)].get
    end
    
  end
end