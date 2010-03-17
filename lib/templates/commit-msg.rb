#!/usr/bin/env ruby

require "rubygems"
require "commit_hookr"
load    ".hookr"
 
CommitHookr.new(ARGV[0]).run