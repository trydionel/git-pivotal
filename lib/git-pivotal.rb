$:.unshift(File.dirname(__FILE__))

require File.join('commands', 'base')
require File.join('commands', 'pick')
require File.join('commands', 'feature')
require File.join('commands', 'bug')
require File.join('commands', 'chore')
require File.join('commands', 'finish')