Feature: General Git Pivotal story-picking features

  Background:
    Given I have a Pivotal Tracker feature
    And a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = 10bfe281783e2bdc2d6592c0ea21e8d5
              full-name = Jeff Tucker
              integration-branch = develop
              project-id = 52815
      """

  Scenario: Giving better error messaging
    Given the feature is unestimated
    When I run "git-feature -D"
    Then the output should contain:
      """
      Stories in the started state must be estimated.
      """
    And the exit status should be 1
