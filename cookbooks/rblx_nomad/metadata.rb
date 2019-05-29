name 'rblx_nomad'
maintainer 'Erin Reed'
maintainer_email 'ereed@roblox.com'
license 'All Rights Reserved'
description 'Installs/Configures Nomad'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
chef_version '>= 14.0'
issues_url 'https://github.com/Roblox/rblx_chef_infrastructure/issues'
source_url 'https://github.com/Roblox/rblx_chef_infrastructure/tree/master/cookbooks/rblx_nomad'

# Roblox Cookbooks
depends 'rblx_utils'

# Public Cookbooks
depends 'docker'

# OS Supported
supports 'ubuntu', '= 18.04'
