require 'optparse'

class Pick
  
  attr_accessor :options
  
  def initialize(*args)
    @options = {}
    parse_gitconfig
    parse_argv(*args)
  end
  
  def run!
    unless options[:api_token] && options[:project_id]
      puts "Pivotal Tracker API Token and Project ID are required"
      return 1
    end
    
    puts "Retrieving latest stories from Pivotal Tracker..."
    api = Pivotal::Api.new(:api_token => options[:api_token])

    project = api.projects.find(:id => options[:project_id])
    story = project.stories.find(:conditions => { :story_type => :feature, :current_state => :unstarted }, :limit => 1).first
    
    unless story
      puts "No stories available!"
      return 0
    end
    
    puts "Story: #{story.name}"
    puts "URL:   #{story.url}"

    suffix = "feature"
    unless options[:quiet]
      print "Enter branch name (will be prepended by #{story.id}) [feature]: "
      suffix = gets.chomp
      
      suffix = "feature" if suffix == ""
    end

    puts "Creating branch..."
    branch = "#{story.id}-#{suffix}"
    create_branch branch
    
    puts "Updating story status in Pivotal Tracker..."
    story.start!(:owned_by => options[:full_name])
    
    return 0
  end
  
private
  
  def sys(cmd)
    puts cmd if options[:verbose]
    system cmd
  end
  
  def get(cmd)
    puts cmd if options[:verbose]
    `#{cmd}`
  end
  
  def parse_gitconfig
    token = get("git config --get pivotal.api-token").strip
    id    = get("git config --get pivotal.project-id").strip
    name  = get("git config --get pivotal.full-name").strip
    
    options[:api_token] = token if token
    options[:project_id] = id if id
    options[:full_name] = name if name
  end
  
  def parse_argv(*args)
    OptionParser.new do |opts|
      opts.banner = "Usage: git pick [options]"
      opts.on("-k", "--api-key=", "Pivotal Tracker API key") { |k| options[:api_token] = k }
      opts.on("-p", "--project-id=", "Pivotal Trakcer project id") { |p| options[:project_id] = p }
      opts.on("-n", "--full-name=", "Pivotal Trakcer full name") { |n| options[:full_name] = n }
      opts.on("-q", "--quiet", "Quiet, no-interaction mode") { |q| options[:quiet] = q }
      opts.on("-v", "--[no-]verbose", "Run verbosely") { |v| options[:verbose] = v }
      opts.on_tail("-h", "--help", "This usage guide") { puts opts; exit 0 }
    end.parse!(args)
  end
  
  def agrees?(selection)
    selection =~ /y/i || selection == ""
  end
  
  def create_branch(branch)
    unless branch_exists?(branch)
      puts "Creating #{branch} branch..."
      sys "git checkout -b #{branch}"
    end
  end

  def branch_exists?(branch)
    !get("git branch").match(branch).nil?
  end

end