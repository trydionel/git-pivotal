require 'fileutils'
require 'mocha'

Before do
  @output_buffer = StringIO.new
  build_temp_paths
  set_env_variables
end

def build_temp_paths(allow_config = true)
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