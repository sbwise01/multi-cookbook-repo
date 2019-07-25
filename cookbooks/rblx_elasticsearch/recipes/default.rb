#
# Cookbook:: rblx_elasticsearch
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# This is used to create the roles.yml file
require 'yaml'

version = node['rblx_elasticsearch']['version']
es_major_version = version.to_s.empty? ? '7' : version.to_i.to_s

# ES <7 requires a JDK to be installed separately
include_recipe 'java' if es_major_version.to_i < 7

# Putting this first will force an apt-get update so we won't need
# to include the apt cookbook for testing
apt_repository 'elastic' do
  uri "https://artifacts.elastic.co/packages/#{es_major_version}.x/apt"
  key 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
  components ['main']
  distribution 'stable'
  only_if { node['platform'] == 'ubuntu' }
end

yum_repository 'elastic' do
  baseurl "https://artifacts.elastic.co/packages/#{es_major_version}.x/yum"
  gpgkey 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
  only_if { node['platform'] == 'centos' }
end

package 'elasticsearch' do
  unless version.to_s.empty?
    version version.to_s
  end
end

service 'elasticsearch' do
  action %i[enable start]
end

## Add all of the configuration files
rou = node['rblx_elasticsearch']['restart_on_update']
template '/etc/elasticsearch/elasticsearch.yml' do
  source 'elasticsearch.yml.erb'
  cookbook 'rblx_elasticsearch'
  owner 'root'
  group 'elasticsearch'
  mode 0o660
  helpers(RblxElasticsearch::ConfigWalkerHelpers)
  variables(config: node['rblx_elasticsearch']['config'])
  if rou
    notifies :restart, 'service[elasticsearch]', :immediately
  end
end

node['rblx_elasticsearch']['config_file'].each do |file_name, vals|
  template "/etc/elasticsearch/#{file_name}" do
    source vals['source']
    cookbook vals['cookbook']
    owner 'root'
    group 'elasticsearch'
    mode 0o660
    variables(vals['variables'])
    if rou
      notifies :restart, 'service[elasticsearch]', :delayed
    end
  end
end

# Create the roles.yml file
roles_data = ''
unless node['rblx_elasticsearch']['roles'].empty?
  roles_data = YAML.dump(node['rblx_elasticsearch']['roles'].to_hash)
end
template '/etc/elasticsearch/roles.yml' do
  owner 'root'
  group 'elasticsearch'
  mode 0o660
  variables(roles: roles_data)
  action :create
end

# Only add a seed file for hosts discovery if elasticsearch.yml says we should
template '/etc/elasticsearch/unicast_hosts.txt' do
  source node['rblx_elasticsearch']['seed_providers']['template']
  cookbook node['rblx_elasticsearch']['seed_providers']['cookbook']
  owner 'root'
  group 'elasticsearch'
  mode 0o660
  helpers(RblxElasticsearch::ConfigWalkerHelpers)
  variables(config: node['rblx_elasticsearch']['seed_providers']['variables'])
  only_if do
    cfg = node['rblx_elasticsearch']['config']
    cfg.dig('discovery', 'seed_providers') == 'file'
  end
  if rou
    notifies :restart, 'service[elasticsearch]', :immediately
  end
end

# ES6+ create a keystore by default, ES5 does not
execute '/usr/share/elasticsearch/bin/elasticsearch-keystore create' do
  not_if do
    File.exist?('/etc/elasticsearch/elasticsearch.keystore') ||
    node['rblx_elasticsearch']['keystore'].empty?
  end
  if rou
    notifies :restart, 'service[elasticsearch]', :immediately
  end
end

## Add values to the keystore
rblx_elasticsearch_keystore_hash 'keystore_vals' do
  value node['rblx_elasticsearch']['keystore']
  not_if { node['rblx_elasticsearch']['keystore'].empty? }
end

## Activate a license, if there is one
license = node['rblx_elasticsearch']['license']
include_recipe 'rblx_elasticsearch::license' unless license.nil?

## Install any plugins
node['rblx_elasticsearch']['plugins'].each do |name, url|
  rblx_elasticsearch_plugin name do
    unless url.to_s.empty?
      url url.to_s
    end
    if rou
      notifies :restart, 'service[elasticsearch]', :immediately
    end
    subscribes :reinstall, 'package[elasticsearch]', :delayed
  end
end
