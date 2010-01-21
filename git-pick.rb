#!/usr/bin/env ruby

require 'optparse'
require 'pivotal_api'

class Pick
  
  attr_accessor :api
  
  def initialize
    @options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: git pick [options]"
      
      opts.on("-k", "--api-key=", "Pivotal Tracker API key") do |k|
        @options[:key] = k
      end
      
      opts.on("-p", "--project-id=", "Pivotal Trakcer project id") do |p|
        @options[:project] = p
      end
      
      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        @options[:verbose] = v
      end
    end.parse!
    
    @api = PivotalApi.new(@options)
  end
  
  def run
    story = @api.stories.first
    # puts "Story:   #{story.name}"
    # puts "URL:     #{story.url}"
    # puts "Branch:  feature-#{story.id}"
    sys "echo 'Story:  #{story.name}'"
    sys "echo 'URL:    #{story.url}'"
    sys "echo 'Branch: feature-#{story.id}'"
  end
  
private

  def branch_exists?(branch)
    !get("git branch").match(branch).nil?
  end

  def sys(cmd)
    puts cmd if @options[:verbose]
    system cmd
  end
  
  def get(cmd)
    puts cmd if @options[:verbose]
    `#{cmd}`
  end
  
end

if $1 == __FILE__
  Pick.new.run
end
