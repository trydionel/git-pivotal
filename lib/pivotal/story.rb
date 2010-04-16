module Pivotal
  class Story < Base
    
    has_attributes :id, :story_type, :url, :estimate, :current_state,
                   :description, :name, :requested_by, :owned_by,
                   :created_at, :accepted_at, :labels
    
    def start!(options = {})
      return false if feature? && unestimated?
      
      update_attributes(options.merge(:current_state => :started))
    end
    
    def feature?
      story_type == "feature"
    end
    
    def bug?
      story_type == "bug"
    end
    
    def chore?
      story_type == "chore"
    end
    
    def release?
      story_type == "release"
    end
    
    def unestimated?
      estimate == "unestimated"
    end

    def finished_state
      case story_type
        when "chore"
          :accepted
        else
          :finished
      end
    end
  
  end
end
