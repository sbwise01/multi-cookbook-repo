#
# Cookbook:: rblx_nomad
# Recipe:: install_docker
#
# Copyright:: 2019, Roblox, All Rights Reserved.

docker_installation_package 'default' do
  not_if { node['rblx_nomad']['docker']['version'].empty? }
  version node['rblx_nomad']['docker']['version']
  setup_docker_repo true
  action :create
  notifies :start, 'docker_service_manager[default]', :immediately
end

# Ensure that docker is running
docker_service_manager 'default' do
  action :nothing
end
