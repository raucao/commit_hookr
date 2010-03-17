#!/usr/bin/env ruby
require "rubygems"
require "highline"
HighLine.track_eof = false

class CommitHookr
  def self.call(&block)
    @@hook = block
  end
    
  attr_accessor :message, :message_file
  
  def initialize(message_file)
    self.message_file = message_file
    self.message = ""
  end
  
  def original_message
    File.read(message_file)
  end

  def run
    STDIN.reopen '/dev/tty' unless STDIN.tty?
    instance_eval &@@hook
    exit 0
  end

  def ui
    @highline ||= HighLine.new
  end
  
  def abort!
    exit 1
  end
  
  def commit!
    exit 0
  end
  
  def write(message)
    File.open(message_file, "w+") do |f|
      f.write message
    end
  end
end