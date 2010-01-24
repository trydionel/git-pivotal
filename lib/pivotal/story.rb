module Pivotal
  class Story < Base
    
    def start!
      begin
        @story.put "<story><current_state>started</current_state></story>"
      rescue RestClient::RequestFailed => res
        puts res.inspect
      end
    end
  
  end
end