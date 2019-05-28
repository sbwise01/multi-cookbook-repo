#
# Cookbook:: rblx_golang
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

file_name = "go#{node['golang']['version']}.#{node['os']}-#{arch}.tar.gz"
install_dir = "/usr/local/go-#{node['golang']['version']}"

tar_extract "#{Chef::Config['file_cache_path']}/#{file_name}" do
  target_dir '/usr/local'
  checksum node['golang']['checksum']
  compress_char 'z'
  creates "#{install_dir}/bin/go" # double check the #{version} part of this
end

link install_dir do
  to '/usr/local/go'
end
