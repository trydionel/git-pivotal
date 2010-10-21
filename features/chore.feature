Feature: git chore

  Background:
    Given I have a Pivotal Tracker chore

  Scenario: Executing with inline options
    When I run "git-chore -k 10bfe281783e2bdc2d6592c0ea21e8d5 -p 52815 -D"
    Then the output should contain "Switched to a new branch '5799841-chore'"
    And I should be on the "5799841-chore" branch
    
  Scenario: Executing with git configuration
    Given a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = 10bfe281783e2bdc2d6592c0ea21e8d5
              full-name = Jeff Tucker
              integration-branch = develop
              project-id = 52815
      """
    When I run "git-chore -D"
    Then the output should contain "Switched to a new branch '5799841-chore'"
    And I should be on the "5799841-chore" branch  