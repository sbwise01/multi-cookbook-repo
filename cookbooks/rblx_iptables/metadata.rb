name              'rblx_iptables'
maintainer        'Roblox, Inc.'
maintainer_email  'cloudsvcs@roblox.com'
license           'All rights reserved'
description       'Sets up iptables and maintains rules'
version           '0.1.0'
issues_url        'https://github.com/Roblox/rblx_iptables/issues'
source_url        'https://github.com/Roblox/rblx_iptables'
chef_version      '> 12.0.0'

recipe 'iptables', 'Installs iptables and manages iptables rules'

%w(redhat centos debian ubuntu).each do |os|
  supports os
end
