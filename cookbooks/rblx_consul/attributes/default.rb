#
# Cookbook: rblx_consul
#
# Copyright:: 2019, Roblox Inc., All Rights Reserved.
#

default['consul']['install_method'] = 'binary'

default['consul']['service_name'] = 'consul'
default['consul']['service_user'] = 'consul'
default['consul']['service_group'] = 'consul'

default['consul']['version'] = '0.9.3'

default['consul']['config_path'] = '/etc/consul'
default['consul']['config_file'] = 'consul.json'
default['consul']['service']['config_dir'] = 'conf.d'

default['consul']['config']['data_dir'] = '/var/lib/consul'
default['consul']['config']['ca_file'] = '/etc/ssl/CA/ca.crt'
default['consul']['config']['cert_file'] = '/etc/ssl/certs/consul.crt'
default['consul']['config']['key_file'] = '/etc/ssl/private/consul.key'

default['consul']['config']['client_addr'] = '0.0.0.0'
default['consul']['config']['ports'] = {
  'dns' => 8600,
  'http' => 8500,
  'serf_lan' => 8301,
  'serf_wan' => 8302,
  'server' => 8300
}
