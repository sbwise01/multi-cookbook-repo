#
# Cookbook:: rblx_vault
# Recipe:: default
#
# Copyright:: 2019, Roblox Inc., All Rights Reserved.

user node['hashicorp-vault']['service_user']
group node['hashicorp-vault']['service_group'] do
  members node['hashicorp-vault']['service_user']
end

case node['hashicorp-vault']['install_method']
when 'binary'
  include_recipe '::binary'
when 'source'
  include_recipe '::source'
else
  Chef::Log.fatal(
    "rblx_vault: Invalid install_method '#{method}' " +
    '(must be one of binary, source)'
  )
  fail
end

config = vault_config node['hashicorp-vault']['service_name'] do |r|
  if node['hashicorp-vault']['config']
    node['hashicorp-vault']['config'].each_pair { |k, v| r.send(k, v) }
  end
end

directory node['hashicorp-vault']['config_path'] do
  owner node['hashicorp-vault']['service_user']
  group node['hashicorp-vault']['service_group']
  mode '0755'
  action :create
end

config_file = File.join(
  node['hashicorp-vault']['config_path'],
  node['hashicorp-vault']['config_file']
)
file config_file do
  content config.to_json
  mode '0640'
  owner node['hashicorp-vault']['service_user']
  group node['hashicorp-vault']['service_group']
end

if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 6
  template "/etc/init.d/#{node['hashicorp-vault']['service_name']}" do
    source 'sysvinit.service.erb'
    mode '0755'
    owner 'root'
    group 'root'
    variables(
      config_file: config_file,
      log_level: node['hashicorp-vault']['log_level'],
      service_name: node['hashicorp-vault']['service_name'],
      service_user: node['hashicorp-vault']['service_user']
    )
  end
else
  systemd_unit "#{node['hashicorp-vault']['service_name']}.service" do
    content(
      {
        Unit: {
          Description: node['hashicorp-vault']['service_name'],
          After: 'network.target',
          Wants: 'network.target'
        },
        Service: {
          Environment: 'PATH=/usr/local/bin:/usr/bin:/bin',
          RuntimeDirectory: 'vault',
          ExecStart: '/usr/local/bin/vault server' +
            " -config=#{config_file}" +
            " -log-level=#{node['hashicorp-vault']['log_level']}",
          ExecReload: '/bin/kill -HUP $MAINPID',
          KillSignal: 'TERM',
          User: node['hashicorp-vault']['service_user'],
          WorkingDirectory: '/var/run/vault'
        },
        Install: {
          WantedBy: 'multi-user.target'
        }
      }
    )
    action :create
  end
end

service node['hashicorp-vault']['service_name'] do
  action %i[enable start]
  subscribes :restart, "file[#{config_file}]", :delayed
end
