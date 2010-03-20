$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'commit_hookr'
require 'aruba'
require 'fileutils'

require 'test/unit/assertions'

World(Test::Unit::Assertions)
