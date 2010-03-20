When /^I run hookr with "([^\"]*)"$/ do |command|
  When "I run \"#{File.dirname(__FILE__)}/../../bin/hookr #{command}\""
end

Then /^I should see the usage info$/ do
  Then "I should see \"Usage:\""
end

Given /^there are no commit hook files$/ do
  Given "I run \"rm .hook\""
  And "I run \"rm .git/hooks/commit-msg\""
end