#
# Cookbook:: rblx_golang
# Recipe:: default
#
# Copyright:: 2019, Roblox, All Rights Reserved.

case node['golang']['install_method']
when 'package'
  include_recipe '::package'
when 'binary'
  include_recipe '::binary'
when 'source'
  include_recipe '::source'
else
  Chef::Log.fatal(
    "rblx_golang: Invalid install_method '#{method}' " +
    '(must be one of package, binary, source)'
  )
  fail
end
