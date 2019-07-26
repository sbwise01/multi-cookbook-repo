# master_path - The top-level path for Grocery Delivery's work. Most other paths are relative to this. Default: /var/chef/grocery_delivery_work
# repo_url - The URL to clone/checkout if it doesn't exist. Default: nil
# reponame - The relative directory to check the repo out to, inside of master_path. Default: ops
# cookbook_paths - An array of directories that contain cookbooks relative to reponame. Default: ['chef/cookbooks']
# role_path - A directory to find roles in relative to reponame. Default: 'chef/roles'
# role_type - RB or JSON roles? Default: rb
# databag_path - A directory to find databags in relative to reponame. Default: 'chef/databags'
# rev_checkpoint - Name of the file to store the last-uploaded revision, relative to reponame. Default: gd_revision
# knife_config - Knife config to use for uploads. Default: /root/.chef/knife.rb Note: knife.rb will need to set cookbook_path pointing to the cookbook path in the work directory, e.g. /var/chef/grocery_delivery_work/ops/chef/cookbooks
# knife_bin - Path to knife. Default: /opt/chef/bin/knife
# vcs_type - Git or SVN? Default: svn
# vcs_path - Path to git or svn binary. If not given, just uses 'git' or 'svn'. Default: nil
# plugin_path - Path to plugin file. Default: /etc/gd-plugin.rb
# berks - Boolean to determine if we should use berkshelf to resolve dependencies and upload cookbooks. Default: false
# berks_bin - Path to berkshelf. Default: /opt/chefdk/bin/berks

stdout          true
master_path     "/home/circleci/"
reponame        "circleci-workflows"
cookbook_paths  [
    "/home/circleci/circleci-workflows/cookbooks/rblx_consul",
    "/home/circleci/circleci-workflows/cookbooks/rblx_nomad",
    "/home/circleci/circleci-workflows/cookbooks/rblx_vault"
]
role_path       '/home/circleci/circleci-workflows/roles'
databag_path    'data_bags'
rev_checkpoint  'gd_revision'
knife_bin        "/usr/local/bundle/bin/knife"
knife_config     "/home/circleci/circleci-workflows/knife/knife.rb"
vcs_type        'git'
vcs_path         "/usr/bin/git"
repo_url         "https://github.rbx.com/Roblox/orchestration-chef"
berks           false
berks_bin       "/usr/local/bundle/bin/berks"


# grocery-delivery -l /var/lock/grocery_delivery.lock --pidfile /var/tmp/gd.pid -v -v --stdout
