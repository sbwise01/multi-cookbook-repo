#
# Cookbook Name:: rblx_iptables
# Definition:: iptables_rule
#
# Copyright 2018, Roblox, Inc.
#
# All rights reserved - Do Not Redistribute
#

# iptables_rule
#
# This definition creates iptables rules and places them in
# node[:iptables][:rules] for use later by iptables::default.
#
# Actions
#   :create
#   :nothing
#
# Attributes
#   name - options - default
#   table - :filter, :nat - :filter
#   chain - :input, :output, :forward, :prerouting, :postrouting - :input
#   protocol - :tcp, :udp, :udplite, :icmp,
#              :igmp, :esp, :ah, :sctp, or :all - :tcp
#   dport - Numeric destination port - nil
#   jump - :accept, :reject, :drop, :log, :masquerade, :dnat, :snat - :accept
#   log_prefix - String - nil
#   log_level - Numeric level - nil
#   source - address[/mask] - nil
#   destination - address[/mask] - nil
#   input_interface - interface name (+ for wildcard) - nil
#   output_interface - interface name (+ for wildcard) - nil

define :iptables_rule, action: :create, table: :filter, chain: :input, protocol: :tcp, jump: :accept, dport: nil, log_prefix: nil, log_level: nil, source: nil, destination: nil, input_interface: nil, output_interface: nil, options: nil do # rubocop:disable Metrics/LineLength
  ruby_block "iptables_rule #{params[:name]}" do
    block do
      node.run_state['rblx_iptables'] = {} unless node.run_state.key?('rblx_iptables') # rubocop:disable Metrics/LineLength

      node.run_state['rblx_iptables']['rules'] = {} unless node.run_state['rblx_iptables'].key?('rules') # rubocop:disable Metrics/LineLength

      node.run_state['rblx_iptables']['rules'][params[:table].to_s] = {} unless node.run_state['rblx_iptables']['rules'].key?(params[:table].to_s) # rubocop:disable Metrics/LineLength

      # Build an iptables rule with the provided parameters.
      if params[:action].to_sym == :create

        iptables_rule = []

        iptables_rule << '--append ' + params[:chain].to_s.upcase
        iptables_rule << '--protocol ' + params[:protocol].to_s if params[:protocol] # rubocop:disable Metrics/LineLength

        iptables_rule << '--destination-port ' + params[:dport].to_s if params[:dport] # rubocop:disable Metrics/LineLength
        iptables_rule << '--jump ' + params[:jump].to_s.upcase if params[:jump]
        iptables_rule << '--log-prefix ' + params[:log_prefix].to_s if params[:log_prefix] && (params[:jump].to_sym == :log) # rubocop:disable Metrics/LineLength
        iptables_rule << '--log-level ' + params[:log_level].to_s if params[:log_level] && (params[:jump].to_sym == :log) # rubocop:disable Metrics/LineLength

        iptables_rule << '--source ' + params[:source].to_s if params[:source]
        iptables_rule << '--destination ' + params[:destination].to_s if params[:destination] # rubocop:disable Metrics/LineLength
        iptables_rule << '--in-interface ' + params[:input_interface].to_s if params[:input_interface] # rubocop:disable Metrics/LineLength
        iptables_rule << '--out-interface ' + params[:output_interface].to_s if params[:output_interface] # rubocop:disable Metrics/LineLength

        iptables_rule << params[:options] if params[:options]

        # Add the rule to the list.
        rule = iptables_rule.join(' ')

        node.run_state['rblx_iptables']['rules'][params[:table].to_s][params[:name].gsub(/\s+/, '_').gsub(/\W+/, '')] = rule # rubocop:disable Metrics/LineLength ~FC039

        Chef::Log.info(rule)
      end
    end

    action params[:action].to_sym
  end
end
