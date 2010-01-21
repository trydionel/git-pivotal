#!/usr/bin/env ruby

require 'optparse'
require 'pivotal_api'

class Pick
  
  attr_accessor :api
  attr_accessor :options
  
  def initialize
    @options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: git pick [options]"
      
      opts.on("-k", "--api-key=", "Pivotal Tracker API key") do |k|
        options[:key] = k
      end
      
      opts.on("-p", "--project-id=", "Pivotal Trakcer project id") do |p|
        options[:project] = p
      end
      
      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        options[:verbose] = v
      end
    end.parse!
    
    @api = PivotalApi.new(options)
  end
  
  def run
    sys "echo '#{@api.stories.first.name}'"
  end
  
private

  def sys(cmd)
    puts cmd if options[:verbose]
    system cmd
  end
  
end

Pick.new.run
