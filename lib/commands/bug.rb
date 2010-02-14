require 'commands/pick'

module Commands
  class Bug < Pick

    def type
      "bug"
    end
    
    def plural_type
      "bugs"
    end
    
    def branch_suffix
      "bugfix"
    end

  end
end