#Git Pivotal

##Prelude
You might want to have [this song](http://www.dailymotion.com/video/x9vzh0_olivia-newton-john-lets-get-physica_music) running in the background while you read this.

##Let's Git Pivotal
Inspired by [Hashrocket's blend of git and Pivotal Tracker](http://reinh.com/blog/2009/03/02/a-git-workflow-for-agile-teams.html) and [a popular article on effective git workflows](http://nvie.com/archives/323), I set off to create a set of utilities to simplify the workflow between the two.

###Git Pick
The original `git pick` has been deprecated.  Three new commands take its place: `git feature`, `git bug` and `git chore`, which collects the top-most available feature, bug or chore (respectively) from your Pivotal Tracker, and offers to create a feature branch.

    1 git-pick:master % git feature
    Collecting latest stories from Pivotal Tracker...
    Story: Test git pivotal
    URL:   http://www.pivotaltracker.com/story/show/1234567
    Updating story status in Pivotal Tracker...
    Enter branch name (will be prepended by 1234567) [feature]: testing
    Creating 1234567-testing branch...
    2 git-pick:1234567-testing %
    
###Git Finish
When on a feature branch, this command will close the associated story in Pivotal Tracker, merge the branch into the master branch and remove the feature branch.

    3 git-pick:1234567-testing % git finish
    Marking Story 1234567 as finished...
    Merging 1234567-testing into master
    Removing 1234567-testing branch
    4 git-pick:master %

##Installation
To install git-pivotal, simply run

    [sudo] gem install git-pivotal

<h2 id="config">Configuration</h2>
Once installed, git pivotal needs three bits of info: your Pivotal Tracker API Token, your name as it appears in Pivotal Tracker and your Pivotal Tracker project id.  The former two are best set as a global git config options:

    git config --global pivotal.api-token 9a9a9a9a9a9a9a9a9a9a
    git config --global pivotal.full-name "Jeff Tucker"

If you prefer to merge back to a branch other than master when you've finished a story, you can configure that:

    git config --global pivotal.integration-branch develop

The project id is best placed within your project's git config:

    git config -f .git/config pivotal.project-id 88888

If you're not interested in storing these options in git, you can pass them into git pivotal as command line arguments.  See the usage guides for more details.

Optionally, if you only want to pick up bugs/features/chores that are already assigned to you, set:

    git config -f .git/config pivotal.only-mine 1

##TODO
This is <del>some seriously</del> alpha software.  Several things on the ol' todo list:

* <del>Create a general Pivotal::Base#update_attributes method</del>
* <del>`git pick` doesn't update the story to indicate who claimed it</del>
* <del>Add command to close/finish currently 'picked' feature</del>
* <del>Reduce verbosity of `git pick`</del>
* <del>Allow users to define their development branch name for `git finish`</del>
* More that I can't recall at the moment
