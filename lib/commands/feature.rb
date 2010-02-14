require 'commands/pick'

module Commands
  class Feature < Pick

    def type
      "feature"
    end
    
    def plural_type
      "features"
    end
    
    def branch_suffix
      "feature"
    end

  end
end