require 'rubygems'
require 'pivotal-tracker'
require 'optparse'

module Commands
  class Base

    attr_accessor :input, :output, :options

    def initialize(input=STDIN, output=STDOUT, *args)
      @input = input
      @output = output
      @options = {}

      parse_gitconfig
      remaining = parse_argv(*args)

      if remaining.one?
        @options[:story_id] = remaining.first
      end
    end

    def put(string, newline=true)
      @output.print(newline ? string + "\n" : string) unless options[:quiet]
    end

    def sys(cmd)
      put cmd if options[:verbose]
      system "#{cmd} > /dev/null 2>&1"
    end

    def get(cmd)
      put cmd if options[:verbose]
      `#{cmd}`
    end

    def run!
      unless options[:api_token] && options[:project_id]
        put "Pivotal Tracker API Token and Project ID are required"
        return 1
      end

      PivotalTracker::Client.token = options[:api_token]
      PivotalTracker::Client.use_ssl = options[:use_ssl]

      return 0
    end

  protected

    def current_branch
      @current_branch ||= get('git symbolic-ref HEAD').chomp.split('/').last
    end

    def project
      @project ||= PivotalTracker::Project.find(options[:project_id])
    end

    def integration_branch
      options[:integration_branch] || "master"
    end

  private

    def parse_gitconfig
      token              = get("git config --get pivotal.api-token").strip
      id                 = get("git config --get pivotal.project-id").strip
      name               = get("git config --get pivotal.full-name").strip
      integration_branch = get("git config --get pivotal.integration-branch").strip
      only_mine          = get("git config --get pivotal.only-mine").strip
      append_name        = get("git config --get pivotal.append-name").strip
      use_ssl            = get("git config --get pivotal.use-ssl").strip

      options[:api_token]          = token              unless token == ""
      options[:project_id]         = id                 unless id == ""
      options[:full_name]          = name               unless name == ""
      options[:integration_branch] = integration_branch unless integration_branch == ""
      options[:only_mine]          = (only_mine != "")  unless name == ""
      options[:append_name]        = (append_name != "")
      options[:use_ssl] = (/^true$/i.match(use_ssl))
    end

    def parse_argv(*args)
      OptionParser.new do |opts|
        opts.banner = "Usage: git pick [options] [story_id]"
        opts.on("-k", "--api-key=", "Pivotal Tracker API key") { |k| options[:api_token] = k }
        opts.on("-p", "--project-id=", "Pivotal Trakcer project id") { |p| options[:project_id] = p }
        opts.on("-n", "--full-name=", "Pivotal Trakcer full name") { |n| options[:full_name] = n }
        opts.on("-b", "--integration-branch=", "The branch to merge finished stories back down onto") { |b| options[:integration_branch] = b }
        opts.on("-m", "--only-mine", "Only select Pivotal Tracker stories assigned to you") { |m| options[:only_mine] = m }
        opts.on("-S", "--use-ssl", "Use SSL for connection to Pivotal Tracker (for private repos(?))") { |s| options[:use_ssl] = s }
        opts.on("-a", "--append-name", "whether to append the story id to branch name instead of prepend") { |a| options[:append_name] = a }
        opts.on("-D", "--defaults", "Accept default options. No-interaction mode") { |d| options[:defaults] = d }
        opts.on("-q", "--quiet", "Quiet, no-interaction mode") { |q| options[:quiet] = q }
        opts.on("-v", "--[no-]verbose", "Run verbosely") { |v| options[:verbose] = v }
        opts.on_tail("-h", "--help", "This usage guide") { put opts.to_s; exit 0 }
      end.parse!(args)
    end

  end
end
