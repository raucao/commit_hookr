Feature: commit_hookr Command Line Interface
  In order to set up interactive Git commit menus
  As a cool developer
  I want to use the hookr command to add and remove commit hooks

  Background:
    Given a directory named "~/some_project"
    And I cd to "~/some_project"
    And I run "git init"

  Scenario: Run hookr in a directory that's not a Git project root
    Given I run "rm -rf .git"
    When I run hookr with "init codebase"
    Then I should see "You should do this in the root directory of a Git project."
    And the exit status should be 1

  Scenario: Run hookr without telling it what to do
    When I run hookr with ""
    Then I should see the usage info
    And the exit status should be 1

  Scenario: Initialize commit hook    
    When I run hookr with "init"
    Then I should see the usage info
    And the exit status should be 1
    
    When I run hookr with "init lighthouse"
    Then I should see "Sorry, the only template available right now is 'codebase'."
    And the exit status should be 1
    
    When I run hookr with "init codebase"
    Then I should see "Yo dawg I herd u like commit hooks, so I put some file in ur directories:"
    And the exit status should be 0
    And the following files should exist:
      | .hookr                |
      | .git/hooks/commit-msg |
    
  Scenario: Clear commit hook
    When I run hookr with "init codebase"
    When I run hookr with "clear"
    Then I should see "Well then, if it makes you happy..."
    
  Scenario: Clear non-existent commit hook
    Given there are no commit hook files
    When I run hookr with "clear"
    Then I should see "There's nothing to clear."
