require 'fileutils'
require 'mocha'

Before do
  @output_buffer = StringIO.new
end

Before('@no-gitconfig') do
  Commands::Feature.any_instance.stubs(:parse_gitconfig).returns(nil)
end

# Around('@no-gitconfig') do |scenario, block|
#   in_temp_repo(false, &block)
# end
# 
Around do |scenario, block|
  in_current_dir do
    in_temp_repo(&block)
  end
  FileUtils.rm_rf(current_dir)
end

After do
  if defined?(@story)
    @story.delete
  end
end

def build_temp_paths(allow_config = true)
  test_repo = File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_repo'))
  # filename = 'git_test' + Time.now.to_i.to_s + rand(300).to_s.rjust(3, '0')
  # @temp_path = File.join("/tmp", filename)
  #
  # FileUtils.mkdir(@temp_path)

  FileUtils.cp_r(test_repo, '.')
  FileUtils.mv(File.join('test_repo', 'working.git'), File.join('test_repo', '.git'))

  if allow_config
    FileUtils.cp(File.join(test_repo, 'gitconfig'), File.join('.', '.gitconfig'))
  end
end

def set_env_variables
  @original_git_dir = ENV["GIT_DIR"]
  @original_git_work_tree = ENV["GIT_WORK_TREE"]
  @original_home = ENV["HOME"]

  ENV["GIT_DIR"] = File.expand_path(File.join('test_repo', '.git'))
  ENV["GIT_WORK_TREE"] = File.expand_path(File.join('test_repo'))
  ENV["HOME"] = File.expand_path(current_dir)
end

def in_temp_repo(allow_config = true, &block)
  build_temp_paths(allow_config)
  set_env_variables
  Dir.chdir('test_repo') do
    block.call
  end
  remove_temp_paths
end

def remove_temp_paths
  ENV["HOME"] = @original_home
  ENV["GIT_DIR"] = @original_git_dir
  ENV["GIT_WORK_TREE"] = @original_git_work_tree
  FileUtils.rm_r(@temp_path)
end