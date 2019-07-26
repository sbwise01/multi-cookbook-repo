rblx_chef_infrastructure

# Roblox Chef Infrastructure
This is the primary repo for the Roblox production services Chef Infrastructure. This repo uses the Chef Repo format for storing Cookbooks, Data Bags, Environments, Roles, and Lint Configurations

## Directories
**/cookbooks**:
This directory contains all the cookbooks that are synced with the Chef server

**/data_bags**:
This directory contains all the data bags that are synced with the Chef server

**/docs**:
This directory contains misc documentation

**/environments**:
This directory contains the environments that are synced with the Chef server 

**/roles**:
This directory contains the roles that are synced with the Chef server

**/spec**:
This directory contains the lint configurations used by Jenkins

## Making changes
Changes to this repo need to be made through feature pull requests.

* Start by cloning this repository locally through your git client
* If your git client supports `Git Flow` then initialize git flow with the following settings
  * Master and Develop branches are set to `Master`
  * Feature branch is set to `feature/`
  * The other branches, Release and Hotfix are not used
* Create a new feature branch, this branch should be named `feature/{feature name}` where feature name is the feature you are adding / editing
* When your feature is complete, push this back to github
* Create a pull request requesting to pull your feature into master

Before pushing your changes, please make sure to read the cookbook standards in the `docs` folder in the root of this repo. All changes and additions to this repository should follow these standards. If you have any questions, please reach out to the Prod Services team.

Things to note:
* Pull request branches must start with `feature/`, this is required for Jenkins to automatically lint the changes
* Pull requests **must** pass automatic lint and peer review to be accepted into the master branch

## Creating a new Cookbook
When adding a new cookbook to this repo please note the following:
* All Roblox corporate cookbooks must start with `rblx_`
* Community cookbooks can be added, however thought around this should be taken, using community code can cause issues in the long run, so community cookbooks should only be added if absolutely required. Make sure to get all required dependencies
* Make sure cookbook follows all Roblox standards for copyright and metadata. See the docs folder for this documentation
* Berkshelf file must be updated for the Chef Repo, see documentation in the docs folder.

## Linting
All cookbook changes are linted automatically with Jenkins using the rules found in the `/spec` directory.

If you want to lint your code locally before pushing your code up to github do the following:
* Open your shell client, navigate to the root of the repo and run `bundle install` this will install all the required gems for linting
* Lint your changes with Rubycop by running `rspec spec/lint/ruby/run_rubocop.rb`
* Lint your changes with Food Critic by running `spec/lint/chef/run_foodcritic.rb`

Note:
* If you are using a Mac, make sure your ruby environment is setup correctly, see the documentation in the docs folder.

# Secrets in Circle CI
## Chef Private Key
* Copy key to matt
```
cat matt.txt | base64 -w0
```
* copy that to an environment variable in circleci
* 