#
# Cookbook:: rblx_golang
# Recipe:: _testprep
#
# Copyright:: 2019, Roblox, All Rights Reserved.
#
# NOTE:  Only use this recipe with kitchen tests

directory '/tmp/testfiles' do
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end

directory '/tmp/testfiles/hello_world' do
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end

cookbook_file '/tmp/testfiles/hello_world/hello_world.go' do
  source 'hello_world.go'
  owner 'root'
  group 'root'
  mode '0666'
end
