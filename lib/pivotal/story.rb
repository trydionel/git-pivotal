module Pivotal
  class Story < Base
    
    has_attributes :id, :story_type, :url, :estimate, :current_state,
                   :description, :name, :requested_by, :owned_by,
                   :created_at, :accepted_at, :labels
    
    def start!(options = {})
      update_attributes(options.merge(:current_state => :started))
    end
  
  end
end