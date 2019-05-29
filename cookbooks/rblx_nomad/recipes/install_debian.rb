#
# Cookbook:: rblx_nomad
# Recipe:: install_docker
#
# Copyright:: 2019, Roblox, All Rights Reserved.

# Update apt
apt_update 'default' do
  action :update
end

# Install required packages
%w(
  gnupg2
  unzip
).each do |pkg|
  apt_package pkg do
    action :install
  end
end

include_recipe 'rblx_nomad::install_docker'
include_recipe 'rblx_nomad::install_nomad_linux'
include_recipe 'rblx_nomad::configure_nomad'
include_recipe 'rblx_nomad::service_nomad_systemd'
