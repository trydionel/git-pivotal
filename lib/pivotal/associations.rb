module Pivotal
  module Associations
    
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def has_collection(name, options = {})
        define_method name do
          Pivotal::Collection.new resource[name], options[:of]
        end
      end
    end
    
  end
end