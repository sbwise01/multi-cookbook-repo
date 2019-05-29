name 'rblx_utils'
maintainer 'Erin Reed'
maintainer_email 'ereed@roblox.com'
license 'All Rights Reserved'
description 'Provides misc library resources'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
chef_version '>= 14.0'
issues_url 'https://github.com/Roblox/rblx_chef_infrastructure/issues'
source_url 'https://github.com/Roblox/rblx_chef_infrastructure/tree/master/cookbooks/rblx_utils'

# OS Supported
%w[
  aix
  amazon
  centos
  fedora
  freebsd
  debian
  oracle
  mac_os_x
  redhat
  suse
  opensuse
  opensuseleap
  ubuntu
  windows
  zlinux
].each do |os|
  supports os
end
