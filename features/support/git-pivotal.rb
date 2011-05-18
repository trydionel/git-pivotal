require 'fileutils'

PIVOTAL_API_KEY = "10bfe281783e2bdc2d6592c0ea21e8d5"
PIVOTAL_TEST_PROJECT = 52815
PIVOTAL_TEST_ID = 5799841

Before do
  @aruba_timeout_seconds = 5
  build_temp_paths
  set_env_variables
end

at_exit do
  # The features seem to have trouble repeating accurately without
  # setting the test story to an unstarted feature for the next run.
  update_test_story("feature", :current_state => "unstarted")
end

def build_temp_paths
  _mkdir(current_dir)

  test_repo = File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_repo'))
  FileUtils.cp_r(test_repo, current_dir)
  Dir.chdir(File.join(current_dir, 'test_repo')) do
    FileUtils.mv('working.git', '.git')
  end
end

def set_env_variables
  set_env "GIT_DIR", File.expand_path(File.join(current_dir, 'test_repo', '.git'))
  set_env "GIT_WORK_TREE", File.expand_path(File.join(current_dir, 'test_repo'))
  set_env "HOME", File.expand_path(current_dir)
end

def update_test_story(type, options = {})
  PivotalTracker::Client.token = PIVOTAL_API_KEY
  project = PivotalTracker::Project.find(PIVOTAL_TEST_PROJECT)
  story   = project.stories.find(PIVOTAL_TEST_ID)

  story.update({
    :story_type    => type.to_s,
    :current_state => "unstarted",
    :estimate      => (type.to_s == "feature" ? 1 : nil)
  }.merge(options))
  sleep(4) # let the data propagate
end

def current_branch
  `git symbolic-ref HEAD`.chomp.split('/').last
end
