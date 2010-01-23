require 'optparse'

class Pick
  
  attr_accessor :api
  
  def initialize
    @options = {}
    parse_gitconfig
    parse_argv    
  end
  
  def run
    connect_to_pivotal
    
    story = find_story
    build_feature_branch story
    start_story story
  end
  
private
  
  def sys(cmd)
    puts cmd if @options[:verbose]
    system cmd
  end
  
  def get(cmd)
    puts cmd if @options[:verbose]
    `#{cmd}`
  end
  
  def parse_gitconfig
    token = get("git config --get pivotal.api-token").strip
    id    = get("git config --get pivotal.project-id").strip
    
    @options[:key] = token if token
    @options[:project] = id if id
  end
  
  def parse_argv
    OptionParser.new do |opts|
      opts.banner = "Usage: git pick [options]"
      opts.on("-k", "--api-key=", "Pivotal Tracker API key") { |k| @options[:key] = k }
      opts.on("-p", "--project-id=", "Pivotal Trakcer project id") { |p| @options[:project] = p }
      opts.on("-q", "--quiet", "Quiet, no-interaction mode") { |q| @options[:quiet] = q }
      opts.on("-v", "--[no-]verbose", "Run verbosely") { |v| @options[:verbose] = v }
      opts.on_tail("-h", "--help", "This usage guide") { puts opts; exit 0 }
    end.parse!
  end
  
  def connect_to_pivotal
    unless @options[:key] && @options[:project]
      puts "Pivotal Tracker API Token and Project ID are required"
      exit 0
    end
    
    puts "Retrieving latest stories from Pivotal Tracker..."
    @api = PivotalApi.new(@options)
  end
  
  def agrees?(selection)
    selection =~ /y/i || selection == ""
  end
  
  def find_story
    story = @api.stories.first
    
    unless story
      puts "No stories available!"
      exit 0
    end
    
    puts "Story: #{story.name}"
    puts "URL:   #{story.url}"
    print prompt + " (Yn): "
    selection = gets.chomp
        
    exit 0 if !agrees?(selection)
    
    story
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

  def build_feature_branch
    branch = "feature-#{story.id}"

    puts "Suggested branch name: #{branch}"
    print prompt + " (Yn): "
    selection = gets.chomp

    unless agrees?(selection)
      print "Enter new name (will be prepended by #{story.id}): "
      branch = "#{story.id}-" + gets.chomp
    end
    
    create_branch branch
  end
  
  def start_story(story)
    puts "Updating story status in Pivotal Tracker..."
    story.start!
  end

end