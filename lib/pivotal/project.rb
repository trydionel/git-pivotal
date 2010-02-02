module Pivotal
  class Project < Base

    has_collection :stories, :of => Pivotal::Story
    has_attributes :id, :name, :iteration_length, :week_start_day,
                   :point_scale, :account, :velocity_scheme,
                   :current_velocity, :initial_velocity,
                   :number_of_iterations_to_show, :labels,
                   :allow_attachments, :public, :use_https,
                   :bugs_and_chores_are_estimatable, :commit_mode,
                   :last_activity_at, :memberships, :integrations

  end
end