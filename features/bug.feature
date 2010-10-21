Feature: git bug

  Background:
    Given I have a Pivotal Tracker bug

  Scenario: Verifying created branch
    When I run "git-bug -k 10bfe281783e2bdc2d6592c0ea21e8d5 -p 52815 -D"
    Then the output should contain "Switched to a new branch '5799841-bugfix'"
    And I should be on the "5799841-bugfix" branch