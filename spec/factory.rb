class Factory
  class << self
    def factories
      @@factories ||= {}
    end
    
    def define(type, attributes)
      factories[type] = attributes
    end
  end
end


def Factory(type, attrs = {})
  defaults = Factory.factories[type]
  attrs = defaults.merge(attrs)
  
  markup = Builder::XmlMarkup.new
  markup.__send__(type) do
    attrs.each do |attribute, value|
      markup.__send__(attribute, value.to_s)
    end
  end
  
  markup.target!
end