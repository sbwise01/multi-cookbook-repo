#
# Cookbook:: rblx_nomad
# Recipe:: default
#
# Copyright:: 2019, Roblox, All Rights Reserved.

# Include recipe for the operating system
# ---------------------------------------
include_recipe "rblx_nomad::install_#{node['platform_family']}"
