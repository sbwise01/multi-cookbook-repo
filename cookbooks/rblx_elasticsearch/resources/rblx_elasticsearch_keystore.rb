# To learn more about Custom Resources,
# see https://docs.chef.io/custom_resources.html

require 'mixlib/shellout'

resource_name :rblx_elasticsearch_keystore
property :value, String, required: true, sensitive: true, desired_state: false

load_current_value do
  bin_path = '/usr/share/elasticsearch/bin'
  keystore = Mixlib::ShellOut.new(
    "#{bin_path}/elasticsearch-keystore list | grep '#{name}'", timeout: 10
  )
  keystore.run_command
  current_value_does_not_exist! if keystore.stdout.strip.empty?
  name keystore.stdout.strip
end

action :add do
  converge_if_changed do
    bin_path = '/usr/share/elasticsearch/bin'
    keystore = Mixlib::ShellOut.new(
      "#{bin_path}/elasticsearch-keystore add --stdin #{@new_resource.name}",
      input: @new_resource.value, timeout: 10
    )
    keystore.run_command
    puts keystore.stdout
    keystore.error!
  end
end
