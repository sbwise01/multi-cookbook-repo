#
# Cookbook:: rblx_consul
# Recipe:: binary
#
# Copyright:: 2019, Roblox, All Rights Reserved.

arch = node['kernel']['processor']
case arch
when 'x86_64'
  arch = 'amd64'
when 'x86_32'
  arch = '386'
end

file_name = '/tmp/consul.zip'
remote_file file_name do
  source 'https://releases.hashicorp.com/' +
    "consul/#{node['consul']['version']}/" +
    "consul_#{node['consul']['version']}_linux_#{arch}.zip"
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

package 'unzip'

execute '' do
  command "unzip #{file_name} -d /usr/local/bin/"
end
