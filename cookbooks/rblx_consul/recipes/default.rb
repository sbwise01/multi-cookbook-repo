#
# Cookbook:: rblx_consul
# Recipe:: default
#
# Copyright:: 2019, Roblox Inc., All Rights Reserved.

user node['consul']['service_user']
group node['consul']['service_group'] do
  members node['consul']['service_user']
end

case node['consul']['install_method']
when 'binary'
  include_recipe '::binary'
when 'source'
  include_recipe '::source'
else
  Chef::Log.fatal(
    "rblx_consul: Invalid install_method '#{method}' " +
    '(must be one of binary, source)'
  )
  fail
end

config = consul_config node['consul']['service_name'] do |r|
  node['consul']['config']&.each_pair { |k, v| r.send(k, v) }
end

directory node['consul']['config_path'] do
  owner node['consul']['service_user']
  group node['consul']['service_group']
  mode '0755'
  action :create
end

service_config_dir = File.join(
  node['consul']['config_path'],
  node['consul']['service']['config_dir']
)
directory service_config_dir do
  owner node['consul']['service_user']
  group node['consul']['service_group']
  mode '0755'
  action :create
end

directory node['consul']['config']['data_dir'] do
  owner node['consul']['service_user']
  group node['consul']['service_group']
  mode '0755'
  action :create
end

config_file = File.join(
  node['consul']['config_path'],
  node['consul']['config_file']
)
file config_file do
  content config.to_json
  mode '0640'
  owner node['consul']['service_user']
  group node['consul']['service_group']
end

if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 6
  template "/etc/init.d/#{node['consul']['service_name']}" do
    source 'sysvinit.service.erb'
    mode '0755'
    owner 'root'
    group 'root'
    variables(
      config_file: config_file,
      service_config_dir: service_config_dir,
      service_name: node['consul']['service_name'],
      service_user: node['consul']['service_user']
    )
  end
else
  systemd_unit "#{node['consul']['service_name']}.service" do
    content(
      {
        Unit: {
          Description: node['consul']['service_name'],
          After: 'network.target',
          Wants: 'network.target'
        },
        Service: {
          Environment: 'PATH=/usr/local/bin:/usr/bin:/bin',
          RuntimeDirectory: 'consul',
          ExecStart: '/usr/local/bin/consul agent' +
          " -config-file=#{config_file}" +
          " -config-dir=#{service_config_dir}",
          ExecReload: '/bin/kill -HUP $MAINPID',
          KillSignal: 'TERM',
          User: node['consul']['service_user'],
          WorkingDirectory: node['consul']['config']['data_dir']
        },
        Install: {
          WantedBy: 'multi-user.target'
        }
      }
    )
    action :create
  end
end

service node['consul']['service_name'] do
  action %i[enable start]
  subscribes :restart, "file[#{config_file}]", :delayed
end
