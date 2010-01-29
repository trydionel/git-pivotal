module Pivotal
  class Story < Base
    
    def start!(options = {})
      update_attributes(options.merge(:current_state => :started))
    end
  
  end
end