require 'fileutils'
require 'mocha'

Before do
  @output_buffer = StringIO.new
end

Before('@no-gitconfig') do
  Commands::Feature.any_instance.stubs(:parse_gitconfig).returns(nil)
end

Around do |scenario, block|
  in_temp_repo(&block)
end

After do
  if defined?(@story)
    @story.delete
  end
end

def build_temp_repo
  test_repo = File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_repo'))
  filename = 'git_test' + Time.now.to_i.to_s + rand(300).to_s.rjust(3, '0')
  @temp_path = File.join("/tmp", filename)
  
  FileUtils.mkdir(@temp_path)
  FileUtils.cp_r(test_repo, @temp_path)
  
  FileUtils.mv(File.join(@temp_path, 'test_repo', 'working.git'), File.join(@temp_path, 'test_repo', '.git'))
end

def set_env_variables
  @original_git_dir = ENV["GIT_DIR"]
  @original_git_work_tree = ENV["GIT_WORK_TREE"]
  
  ENV["GIT_DIR"] = File.join(@temp_path, 'test_repo', '.git')
  ENV["GIT_WORK_TREE"] = File.join(@temp_path, 'test_repo')
end

def in_temp_repo(&block)
  build_temp_repo
  set_env_variables
  Dir.chdir(File.join(@temp_path, 'test_repo')) do
    block.call
  end
  remove_temp_repo
end

def remove_temp_repo
  ENV["GIT_DIR"] = @original_git_dir
  ENV["GIT_WORK_TREE"] = @original_git_work_tree
  FileUtils.rm_r(@temp_path)
end