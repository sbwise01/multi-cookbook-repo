#
# Cookbook:: rblx_nomad
# Recipe:: configure_nomad
#
# Copyright:: 2019, Roblox, All Rights Reserved.

nomad_config_dir = '/etc/nomad'

# Create the configuration directory for nomad
directory nomad_config_dir do
  action :create
end

# TODO: create nomad.hcl...
