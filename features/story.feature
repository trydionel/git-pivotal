Feature: git story

  Scenario: Executing with no settings
    When I run "git-story"
    Then the output should contain:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1
  
  Scenario Outline: Executing with inline options
    Given I have a Pivotal Tracker <type>
    When I run "git-story -k 10bfe281783e2bdc2d6592c0ea21e8d5 -p 52815 -D"
    Then the output should contain:
      """
      Retrieving latest <type>s from Pivotal Tracker...
      Story: Test Story
      URL:   http://www.pivotaltracker.com/story/show/5799841
      Updating <type> status in Pivotal Tracker...
      Switched to a new branch '5799841-<branch>'
      """
    And I should be on the "5799841-<branch>" branch

    Examples:
      | type    | branch  |
      | feature | feature |
      | bug     | bugfix  |
      | chore   | chore   |

  Scenario Outline: Executing with git configuration
    Given I have a Pivotal Tracker <type>
    And a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = 10bfe281783e2bdc2d6592c0ea21e8d5
              full-name = Jeff Tucker
              integration-branch = develop
              project-id = 52815
      """
    When I run "git-story -D"
    Then the output should contain "Switched to a new branch '5799841-<branch>'"
    And I should be on the "5799841-<branch>" branch

    Examples:
      | type    | branch  |
      | feature | feature |
      | bug     | bugfix  |
      | chore   | chore   |
