Feature: git bug

  Background:
    Given I have a Pivotal Tracker bug

  Scenario: Verifying created branch
    When I execute git bug
    Then I should see "Switched to a new branch '4418813-bugfix'"
    And I should be on the "4418813-bugfix" branch