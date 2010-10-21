Feature: git feature

  Background:
    Given I have a Pivotal Tracker feature

  Scenario: Executing with no settings
    When I run "git-feature"
    Then the output should contain:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1
  
  Scenario: Executing with inline options
    When I run "git-feature -k 10bfe281783e2bdc2d6592c0ea21e8d5 -p 52815 -D"
    Then the output should contain:
      """
      Retrieving latest features from Pivotal Tracker...
      Story: Test Story
      URL:   http://www.pivotaltracker.com/story/show/5799841
      Updating feature status in Pivotal Tracker...
      Switched to a new branch '5799841-feature'
      """
    And I should be on the "5799841-feature" branch

  Scenario: Executing with git configuration
    Given a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = 10bfe281783e2bdc2d6592c0ea21e8d5
              full-name = Jeff Tucker
              integration-branch = develop
              project-id = 52815
      """
    When I run "git-feature -D"
    Then the output should contain "Switched to a new branch '5799841-feature'"
    And I should be on the "5799841-feature" branch