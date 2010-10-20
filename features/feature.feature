Feature: git feature

  Background:
    Given I have a Pivotal Tracker feature

  @no-gitconfig
  Scenario: Executing with no settings
    When I execute git feature
    Then I should see "Pivotal Tracker API Token and Project ID are required"
  
  @no-gitconfig
  Scenario: Executing with required settings
    When I execute git feature with:
      | key | value |
      | -k | 10bfe281783e2bdc2d6592c0ea21e8d5 |
      | -p | 52815 |
    Then I should see "Retrieving latest features from Pivotal Tracker..."
  
  Scenario: Verifying created branch
    When I execute git feature
    Then I should see "Switched to a new branch '2265959-feature'"
    And I should be on the "2265959-feature" branch