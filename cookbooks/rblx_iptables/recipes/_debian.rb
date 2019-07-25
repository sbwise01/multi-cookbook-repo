#
# Cookbook Name:: rblx_iptables
# Recipe:: _debian
#
# Copyright 2018 Roblox, Inc.
#
# All rights reserved - Do Not Redistribute
#

package 'iptables-persistent' do
  action %i[install upgrade]
end

template 'iptables' do
  source 'iptables.erb'
  path '/etc/iptables/rules.v4'

  mode 0o600
  owner 'root'
  group 'root'

  action :nothing

  variables node: node

  notifies :restart, 'service[iptables]'

  not_if { $! && !node['rblx_iptables']['rules'].empty? } # rubocop:disable Style/SpecialGlobalVars,Metrics/LineLength
end

service 'iptables' do
  service_name 'netfilter-persistent'

  supports start: true, stop: true, restart: true, status: true, reload: true

  action %i[enable start]
end
