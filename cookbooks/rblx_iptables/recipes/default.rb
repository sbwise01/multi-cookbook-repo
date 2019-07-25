#
# Cookbook Name:: rblx_iptables
# Recipe:: default
#
# Copyright 2018 Roblox, Inc.
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
when 'rhel'
  include_recipe 'rblx_iptables::_rhel'
when 'debian'
  include_recipe 'rblx_iptables::_debian'
else
  fail("Unsupported platform_family: #{node['platform_family']}")
end

# generate rules specified in attributes
node['rblx_iptables']['nat'].each_pair do |name, rule|
  iptables_rule name do
    table 'nat'

    action rule['action'] if rule['action']
    chain rule['chain'] if rule['chain']
    protocol rule['protocol'] if rule['protocol']
    jump rule['jump'] if rule['jump']
    dport rule['dport'] if rule['dport']
    log_prefix rule['log_prefix'] if rule['log_prefix']
    log_level rule['log_level'] if rule['log_level']
    source rule['source'] if rule['source']
    destination rule['destination'] if rule['destination']
    input_interface rule['input_interface'] if rule['input_interface']
    output_interface rule['output_interface'] if rule['output_interface']
    options rule['options'] if rule['options']
  end
end

node['rblx_iptables']['filter'].each_pair do |name, rule|
  iptables_rule name do
    table 'filter'

    action rule['action'] if rule['action']
    chain rule['chain'] if rule['chain']
    protocol rule['protocol'] if rule['protocol']
    jump rule['jump'] if rule['jump']
    dport rule['dport'] if rule['dport']
    log_prefix rule['log_prefix'] if rule['log_prefix']
    log_level rule['log_level'] if rule['log_level']
    source rule['source'] if rule['source']
    destination rule['destination'] if rule['destination']
    input_interface rule['input_interface'] if rule['input_interface']
    output_interface rule['output_interface'] if rule['output_interface']
    options rule['options'] if rule['options']
  end
end

# trigger the iptables template to render at the end of the chef run
log 'notify iptables template to render' do
  notifies :create, 'template[iptables]'
end
