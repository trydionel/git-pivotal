#Git Pivotal

##Prelude
You might want to have [this song](http://www.dailymotion.com/video/x9vzh0_olivia-newton-john-lets-get-physica_music) running in the background while you read this.

##Let's Git Pivotal
Inspired by [Hashrocket's blend of git and Pivotal Tracker](http://reinh.com/blog/2009/03/02/a-git-workflow-for-agile-teams.html) and [a popular article on effective git workflows](http://nvie.com/archives/323), I set off to create a set of utilities to simplify the workflow between the two.

###Git Feature/Bug/Chore
The Git Pivotal utility provides three tools to integrate with your Pivotal Tracker project -- `git feature`, `git bug` and `git chore`.  These commands collect the top-most available feature, bug or chore (respectively) from your Pivotal Tracker and creates a unique feature branch for it.

    1 git-pivotal:master % git feature
    Collecting latest stories from Pivotal Tracker...
    Story: Test git pivotal
    URL:   http://www.pivotaltracker.com/story/show/1234567
    Updating story status in Pivotal Tracker...
    Enter branch name (will be prepended by 1234567) [feature]: testing
    Creating 1234567-testing branch...
    2 git-pivotal:1234567-testing %
    
###Git Finish
When on a feature branch, this command will close the associated story in Pivotal Tracker, merge the branch into your integration branch (`master` by default) and remove the feature branch.

    3 git-pivotal:1234567-testing % git finish
    Marking Story 1234567 as finished...
    Merging 1234567-testing into master
    Removing 1234567-testing branch
    4 git-pivotal:master %

##Installation
To install git-pivotal, simply run

    [sudo] gem install git-pivotal

<h2 id="config">Configuration</h2>
Once installed, git pivotal needs three bits of info: your Pivotal Tracker API Token, your name as it appears in Pivotal Tracker and your Pivotal Tracker project id.  The former two are best set as a global git config options:

    git config --global pivotal.api-token 9a9a9a9a9a9a9a9a9a9a
    git config --global pivotal.full-name "Jeff Tucker"

If you prefer to merge back to a branch other than master when you've finished a story, you can configure that:

    git config --global pivotal.integration-branch develop

If you only want to pick up bugs/features/chores that are already assigned to you, set:

    git config --global pivotal.only-mine true

The project id is best placed within your project's git config:

    git config -f .git/config pivotal.project-id 88888

If you're not interested in storing these options in git, you can pass them into git pivotal as command line arguments.  See the usage guides for more details.

##TODO
This is beta software.  Several things on the ol' todo list:

* <del>Create a general Pivotal::Base#update_attributes method</del>
* <del>`git pick` doesn't update the story to indicate who claimed it</del>
* <del>Add command to close/finish currently 'picked' feature</del>
* <del>Reduce verbosity of `git pick`</del>
* <del>Allow users to define their development branch name for `git finish`</del>
* Add option to install git commit hooks which add commit messages to story comments
* Drop custom Pivotal API in favor of pivotal-tracker gem
* More that I can't recall at the moment
