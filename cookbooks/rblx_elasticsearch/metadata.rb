name 'rblx_elasticsearch'
maintainer        'Roblox, Inc.'
maintainer_email  'cloudsvcs@roblox.com'
license 'All Rights Reserved'
description 'Installs/Configures rblx_elasticsearch'
long_description 'Installs/Configures rblx_elasticsearch'
version '0.1.0'
chef_version '>= 13.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/rblx_elasticsearch/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/rblx_elasticsearch'

supports 'ubuntu', '>= 16.04'
supports 'centos', '>= 7'

depends 'java'
