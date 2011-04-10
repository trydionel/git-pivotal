Feature: git info

  Background:
    Given I have a Pivotal Tracker feature
    And I am on the "5799841-feature" branch

  Scenario: Executing with no settings
    When I run "git-info"
    Then the output should contain:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1

  Scenario: Executing with inline options
    When I run "git-info -k 10bfe281783e2bdc2d6592c0ea21e8d5 -p 52815 -D"
    Then the output should contain:
      """
      Story:         Test Story
      URL:           http://www.pivotaltracker.com/story/show/5799841
      Description:   This is the description!
      """

  Scenario: Executing with git configuration
    Given a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = 10bfe281783e2bdc2d6592c0ea21e8d5
              full-name = Jeff Tucker
              integration-branch = develop
              project-id = 52815
      """
    When I run "git-info"
    Then the output should contain:
      """
      Story:         Test Story
      URL:           http://www.pivotaltracker.com/story/show/5799841
      Description:   This is the description!
      """
