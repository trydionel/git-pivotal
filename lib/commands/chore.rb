require 'commands/pick'

module Commands
  class Chore < Pick

    def type
      "chore"
    end
    
    def plural_type
      "chores"
    end
    
    def branch_suffix
      "chore"
    end

  end
end