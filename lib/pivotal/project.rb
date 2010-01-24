module Pivotal
  class Project < Base

    has_collection :stories, :of => Pivotal::Story

  end
end