# To learn more about Custom Resources,
# see https://docs.chef.io/custom_resources.html

resource_name :rblx_elasticsearch_keystore_hash
property :value, Hash, required: true, sensitive: true, desired_state: false

action :add do
  vals = {}
  @new_resource.value.each do |k, v|
    vals.merge!(parse_values(k, v))
  end
  vals.each do |key, val|
    rblx_elasticsearch_keystore key do
      value val
    end
  end
end

action_class do
  include RblxElasticsearch::ConfigWalkerHelpers
end
