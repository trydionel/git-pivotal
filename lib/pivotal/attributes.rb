module Pivotal
  module Attributes
    
    def self.included(base)
      base.extend ClassMethods

      class << base
        attr_accessor :attributes
      end
    end
    
    module ClassMethods
      def has_attributes(*attributes)
        @attributes = attributes.map(&:to_s)
        
        attributes.each do |attribute|
          define_method attribute do
            parsed_resource.css(attribute.to_s).text
          end
        end
      end
    end
    
  end
end