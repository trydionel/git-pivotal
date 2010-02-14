require File.join(File.dirname(__FILE__), 'factory')

Factory.define :story, {
  :id            => 1,
  :current_state => :unstarted,
  :story_type    => :feature,
  :estimate      => 1,
}

Factory.define :project, {
  :id   => 1,
  :name => "Project"
}