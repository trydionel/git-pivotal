Feature: git chore

  Background:
    Given I have a Pivotal Tracker chore

  Scenario: Verifying created branch
    When I execute git chore
    Then I should see "Switched to a new branch '4418814-chore'"
    And I should be on the "4418814-chore" branch