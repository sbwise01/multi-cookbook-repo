# Roblox Berksfile Standards

The default Berksfile that Chef generates will point to the supermarket

This file needs to be updated to let Berks know that we are using a chef-repo, documentation can be found here: [https://docs.chef.io/berkshelf.html]()

This is an example of how the Berksfile should look
```
source chef_repo: '..'

metadata
```
