#
# Cookbook:: rblx_elasticsearch
# Recipe:: license
#
# Copyright:: 2019, The Authors, All Rights Reserved.

## Get the content of the license one way or another
license = ''
if node['rblx_elasticsearch']['license'].is_a? Hash
  license_path = "#{Chef::Config[:file_cache_path]}/license"
  cookbook_file license_path do
    source node['rblx_elasticsearch']['license']['source']
    cookbook node['rblx_elasticsearch']['license']['cookbook']
    owner 'elasticsearch'
    group 'elasticsearch'
    mode '0640'
    action :create
    sensitive true
    subscribes :delete, "cookbook_file[#{license_path}]", :delayed
  end
  license = IO.read(license_path)
elsif node['rblx_elasticsearch']['license'].is_a? String
  license = node['rblx_elasticsearch']['license']
else
  msg1 = "Recipe #{recipe_name} from #{cookbook_name}"
  msg1 += ' was included in the run_list'
  Chef.log.fatal(msg1)
  msg2 = "but node['rblx_elasticsearch']['license']"
  msg2 += ' is not a string or a hash.'
  Chef.log.fatal(msg2)
end

## Set the URL for the upcoming requests
bsp = node['rblx_elasticsearch']['keystore'].dig('bootstrap', 'password')
url = 'http://'
unless bsp.nil?
  url += "elastic:#{bsp}@"
end
port = node['rblx_elasticsearch']['config'].dig('http', 'port') || 9200
url += "localhost:#{port}"

## Do the thing.
# The hyperlink is a combination of thw two lines below:
# https://www.elastic.co/guide/en/
# elasticsearch/reference/7.1/update-license.html
# Unfortunately there is no way to access the response data from a Chef
# `http_request`, and we need to read a couple of responses in order to
# do this. We'll use Chef's HTTP library so we have an abstraction over
# Ruby - one less thing to deal with - and we'll do it in a `ruby_block`
# so we can at least pretend we're using Chef resources.
#
# The giant not_if block below handles some of the potential issues that can
# come up when hitting the API while it's "running" (per systemctl):
# First, after a license has been activated, it cannot be GET'ed without
#  authentication. If we get a 401, a license has been activated.
# Second and third, we can get either a 404 or a "connection refused"
# while the service is supposedly running, so try again. On a 404 it will
# only retry three times (so 15 requests) in case something else is wrong.
ruby_block 'post_license' do
  block do
    res = Chef::HTTP.new(url).post('/_license', {
      licenses: [JSON.parse(license)['license']]
    }.to_json,
                                   'Content-Type' => 'application/json')

    if JSON.parse(res).dig('acknowledged').is_a? FalseClass
      Chef::HTTP.new(url).post('/_license?acknowledge=true', {
        licenses: [JSON.parse(license)['license']]
      }.to_json,
                               'Content-Type' => 'application/json')
    end
  end
  not_if do
    retries = 0
    begin
      res = Chef::HTTP.new(url).get('/_license')
      dug = JSON.parse(res).dig('license', 'uid')
      dug == JSON.parse(license).dig('license', 'uid')
    rescue Net::HTTPServerException => e
      response = e.response
      if response.is_a?(Net::HTTPUnauthorized)
        msg = 'License already activated or bootstrap password disabled'
        Chef::Log.info(msg)
        true
      elsif response.is_a?(Net::HTTPNotFound)
        # Immediately after ES starts listening, it's possible to get a 404.
        # We give it three attempts to work using the retries variable above
        Chef::Log.info('Elasticsearch up but returning 404, retrying...')
        if (retries += 1) <= 5
          retry
        end
      end
    rescue Errno::ECONNREFUSED
      # ES is not actually listening for a bit after a
      # `systemctl restart` returns - up to 10-20 seconds.
      Chef::Log.info('Elasticsearch not up yet, retrying...')
      if (retries += 1) <= 5
        retry
      end
    end
  end
  # Restart Elasticsearch in case the bootstrap password
  # was added to the keystore without a restart
  notifies :restart, 'service[elasticsearch]', :before if bsp
end
