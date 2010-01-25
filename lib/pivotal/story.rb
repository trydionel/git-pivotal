module Pivotal
  class Story < Base
    
    def start!
      resource.put "<story><current_state>started</current_state></story>"
    end
  
  end
end