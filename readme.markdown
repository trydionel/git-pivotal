#Git Pivotal

##Prelude
You might want to have [this song]("http://www.dailymotion.com/video/x9vzh0_olivia-newton-john-lets-get-physica_music") running in the background while you read this.

##Let's Git Pivotal
Inspired by [Hashrocket's blend of git and Pivotal Tracker]("http://reinh.com/blog/2009/03/02/a-git-workflow-for-agile-teams.html") and [a popular article on effective git workflows]("http://nvie.com/archives/323"), I set off to create a set of utilities to simplify the workflow between the two.

###Git Pick
This selects the top-most available feature from your Pivotal Tracker, and offers to create a feature branch.

    1 git-pick:master % git pick
    Collecting latest stories from Pivotal Tracker...
    Story: Test git pivotal
    URL:   http://www.pivotaltracker.com/story/show/1234567
    Accept this story? (Yn): y
    Suggested branch: feature-1234567
    Accept this name? (Yn): y
    Creating feature-1234567 branch...
    Updating story status in Pivotal Tracker...
    2 git-pick:feature-1234567 %
    
##Installation
To install git-pivotal, simply run

    [sudo] gem install git-pivotal
    
Once installed, git pivotal needs two bits of info: your Pivotal Tracker API Token and your Pivotal Tracker project id.  The former is best set as a global git config option:

    git config --global pivotal.api-token 9a9a9a9a9a9a9a9a9a9a

The project id is best placed within your project's git config:

    git config -f .git/config pivotal.project-id 88888

If you're not interested in storing these options in git, you can pass them into git pivotal as command line arguments.  See the usage guides for more details.

##TODO
This is some serious alpha software.  Several things on the ol' todo list:

* Create a general Pivotal::Base.update_attributes method
* Add command to close/finish currently 'picked' feature
* `git pick` doesn't update the story to indicate who claimed it
* more that I can't recall at the moment
