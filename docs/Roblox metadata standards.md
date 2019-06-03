# Roblox Metadata.rb Standards

The `metadata.rb` file should be updated in Roblox cookbooks to match the following:

```
name 'rblx_{cookbook_name}'
maintainer '{name} or {team_name}'
maintainer_email '{email} or {team_email}'
license 'All Rights Reserved'
description '{short_description}'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
chef_version '>= 14.0'
issues_url 'https://github.com/Roblox/rblx_chef_infrastructure/issues'
source_url 'https://github.com/Roblox/rblx_chef_infrastructure/tree/master/cookbooks/rblx_{cookbook_name}'

# Roblox Cookbooks
depends 'rblx_utils'
depends 'rblx_{other_rblx_cookbook}'

# Public Cookbooks
depends '{public_cookbook}'

# OS Supported
supports 'ubuntu', '= 18.04'
```

Things to note:
* Do not change the version number from `0.1.0`
* If your cookbook supports other operating systems make sure to add them

Supported OS Names:
* aix
* amazon
* centos
* fedora
* freebsd
* debian
* oracle
* mac_os_x
* redhat
* suse
* opensuse
* opensuseleap
* ubuntu
* windows
* zlinux