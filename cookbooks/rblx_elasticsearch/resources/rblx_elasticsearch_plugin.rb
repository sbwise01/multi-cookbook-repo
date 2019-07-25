# To learn more about Custom Resources,
# see https://docs.chef.io/custom_resources.html

# 1. Add run first time <- converge_if_changed with current_value_does_not_exist
# 2. Add run subsequent times <- converge_if_changed
# 3. Add run with different name/url <- converge_if_changed
# 1. Remove run first time <- converge_if_not_changed :)

require 'mixlib/shellout'

resource_name :rblx_elasticsearch_plugin
property :url, String, default: '', coerce: proc { |p| p.empty? ? name : p }

load_current_value do
  bin_path = '/usr/share/elasticsearch/bin'
  plugin = Mixlib::ShellOut.new(
    "#{bin_path}/elasticsearch-plugin list | grep '#{name}'",
    timeout: 10
  )
  plugin.run_command
  name plugin.stdout.strip
end

action :add do
  converge_if_changed do
    cmd = plugin_remove(current_resource.name)
    puts cmd.stdout
    cmd.error!
  end
  unless plugin_exist(new_resource.name)
    cmd = plugin_install(new_resource.url)
    puts cmd.stdout
    cmd.error!
  end
end

action :remove do
  if plugin_exist(new_resource.name)
    cmd = plugin_remove(new_resource.name)
    puts cmd.stdout
    cmd.error!
  end
end

action :reinstall do
  action_remove
  action_add
end

action_class do
  def plugin_search(name)
    bin_path = '/usr/share/elasticsearch/bin'
    plugin = Mixlib::ShellOut.new(
      "#{bin_path}/elasticsearch-plugin list | grep '#{name}'",
      timeout: 10
    )
    plugin.run_command
    plugin
  end

  def plugin_exist(name)
    !plugin_search(name).stdout.strip.empty?
  end

  def plugin_install(url)
    bin_path = '/usr/share/elasticsearch/bin'
    plugin = Mixlib::ShellOut.new(
      "#{bin_path}/elasticsearch-plugin install '#{url}' 2>&1",
      timeout: 300
    )
    plugin.run_command
    plugin
  end

  def plugin_remove(name)
    bin_path = '/usr/share/elasticsearch/bin'
    plugin = Mixlib::ShellOut.new(
      "#{bin_path}/elasticsearch-plugin remove '#{name}' 2>&1",
      timeout: 300
    )
    plugin.run_command
    plugin
  end
end
