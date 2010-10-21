Feature: git finish

  Background:
    Given I have a started Pivotal Tracker feature
    And I am on the "5799841-feature" branch

  Scenario: Executing with no settings
    When I run "git-finish"
    Then the output should contain:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1

  Scenario: Excuting with inline settings
    When I run "git-finish -k 10bfe281783e2bdc2d6592c0ea21e8d5 -p 52815"
    Then the output should contain:
      """
      Marking Story 5799841 as finished...
      Merging 5799841-feature into master
      Removing 5799841-feature branch
      """
    And I should be on the "master" branch
  
  Scenario: Executing with git configuration
    Given a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = 10bfe281783e2bdc2d6592c0ea21e8d5
              full-name = Jeff Tucker
              project-id = 52815
      """
    When I run "git-finish -k 10bfe281783e2bdc2d6592c0ea21e8d5 -p 52815"
    Then the output should contain:
      """
      Marking Story 5799841 as finished...
      Merging 5799841-feature into master
      Removing 5799841-feature branch
      """
    And I should be on the "master" branch
  
  Scenario: Specifying an integration branch
    Given I have a "develop" branch
    And a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = 10bfe281783e2bdc2d6592c0ea21e8d5
              full-name = Jeff Tucker
              integration-branch = develop
              project-id = 52815
      """
    When I run "git-finish -k 10bfe281783e2bdc2d6592c0ea21e8d5 -p 52815"
    Then the output should contain:
      """
      Marking Story 5799841 as finished...
      Merging 5799841-feature into develop
      Removing 5799841-feature branch
      """
    And I should be on the "develop" branch

  Scenario: Closing chore stories
    Given I have a started Pivotal Tracker chore
    And I am on the "5799841-chore" branch
    And a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = 10bfe281783e2bdc2d6592c0ea21e8d5
              full-name = Jeff Tucker
              project-id = 52815
      """
    When I run "git-finish -k 10bfe281783e2bdc2d6592c0ea21e8d5 -p 52815"
    Then the output should contain:
      """
      Marking Story 5799841 as finished...
      Merging 5799841-chore into master
      Removing 5799841-chore branch
      """
    And I should be on the "master" branch
  