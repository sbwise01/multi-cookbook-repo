unless node.normal.key?('rblx_iptables')
  node.normal['rblx_iptables'] = {}
end

unless node.normal['rblx_iptables'].key?('rules')
  node.normal['rblx_iptables']['rules'] = {}
end

if node.normal['rblx_iptables']['rules'].empty?
  normal['rblx_iptables']['rules'] = {}
end

default['rblx_iptables']['filter'] = {}
default['rblx_iptables']['nat'] = {}
