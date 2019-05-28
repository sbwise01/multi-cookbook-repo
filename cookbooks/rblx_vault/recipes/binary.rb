#
# Cookbook:: rblx_vault
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

file_name = '/tmp/vault.zip'
remote_file file_name do
  source 'https://releases.hashicorp.com/' +
    "vault/#{node['hashicorp-vault']['version']}/" +
    "vault_#{node['hashicorp-vault']['version']}_linux_#{arch}.zip"
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

package 'unzip'

execute '' do
  command "unzip #{file_name} -d /usr/local/bin/"
end
