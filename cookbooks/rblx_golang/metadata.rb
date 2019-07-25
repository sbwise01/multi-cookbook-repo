name 'rblx_golang'
maintainer 'Brian Hazeltine'
maintainer_email 'bhazeltine@roblox.com'
license 'All Rights Reserved'
description 'Installs/Configures Golang'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
chef_version '>= 14.0'

recipe 'golang::default', 'Installs and configures Golang'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/rblx_golang/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/rblx_golang'

supports 'ubuntu', '>= 14.04'
supports 'centos', '>= 6'
