# Whether to restart the server when a config file
# is updated, useful for testing
default['rblx_elasticsearch']['restart_on_update'] = false

# Optionally specify a point (ie x.y.z) version of Elasticsearch to install.
# By default it will install the latest (ie 7.x) version from the ES repo.
default['rblx_elasticsearch']['version'] = ''

# Optionally specify a license. This can be done two ways-
# Either pass a String with the JSON contents of the license
# or, to specify a cookbook_file in another cookbook, specify a hash as
# {
#   cookbook: 'my_cookbook',
#   source: 'my_file.json'
# }
# In the latter case, the file will be copied to the instance
# during the Chef run along with the other contents of the cookbooks.
default['rblx_elasticsearch']['license'] = nil

# This attribute defines the contents of elasticsearch.yml.
# The hash will be joined into sets of yml-friendly key=>value pairs.
# For example, { path => logs: '/var/log/elasticsearch' } will become
# path.logs: /var/log/elasticsearch
# Setting `discovery.seed_providers: file` will add a unicast_hosts.txt
# template. The configuration for the template is defined at the bottom
# of this file.
# The default configuration is
# {
#   'path' => {
#     'data': '/var/lib/elasticsearch',
#     'logs': '/var/log/elasticsearch',
#   }
# }
# These defaults will be used if these values are not set.
default['rblx_elasticsearch']['config'] = {
  'xpack' => { 'security' => {
    'authc' => { 'anonymous' => { roles: ['anonymous'] } },
    :enabled => true
  } }
}

# Hashes are munged the same as above,
# but add these values to the keystore instead
default['rblx_elasticsearch']['keystore'] = {}

# Configure roles to be included in roles.yml.
# Keep in mind this will override roles specified via ES API.
# The structure of this hash is the same as the hashes above,
# but the values from this hash are not flattened when they
# are put into the file: they invoke the {}.to_yaml method
# provided by the 'yaml' package
default['rblx_elasticsearch']['roles'] = {}

# List of plugins to install ala `elasticsearch-plugin install val`
# This value is a hash in order to allow plugins to be installed from URLs.
# The syntax is as follows:
# {
#   'community-plugin': nil,
#   'local-plugin':    'file:///some/path',
#   'remote-plugin':   'https://some/url'
# }
default['rblx_elasticsearch']['plugins'] = { 'analysis-icu': nil }

# The remaining configuration files are configured via templates that can be
# overridden in wrapper cookbooks. For simplicity's sake, we'll keep
# elasticsearch.yml out of here and configure it via the `config` attribute.
# In general, none of the templates that these variables map to
# have any configuration, see below for exceptions.
%w(jvm.options
   log4j2.properties
   role_mapping.yml
   users_roles
   users).each do |file_name|
  default['rblx_elasticsearch']['config_file'][file_name] = {
    cookbook: 'rblx_elasticsearch',
    source: "#{file_name}.erb",
    variables: {}
  }
end

# Set the default -Xms and -Xmx to half of the system memory
mem = node['memory']['total'].to_i
default['rblx_elasticsearch']['config_file']['jvm.options']['variables'] = {
  'heap_size' => "#{[(mem * 0.5).floor / 1024, 30500].min}m"
}

# Default logging configuration
cfg_file = default['rblx_elasticsearch']['config_file']
cfg_file['log4j2.properties']['variables'] = {
  'status' => 'error',
  'root_logger_level' => 'info'
}

# Configure unicast_hosts.txt. This template is only included
# if elasticsearch.yml contains `discovery.seed_providers: file`
# as mentioned above.
default['rblx_elasticsearch']['seed_providers'] = {
  'cookbook' => 'rblx_elasticsearch',
  'template' => 'unicast_hosts.txt.erb',
  'variables' => {
    'hosts' => %w()
  }
}
