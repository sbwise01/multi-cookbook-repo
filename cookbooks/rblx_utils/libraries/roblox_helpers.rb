module Roblox
  # Check to see if we are on a 64bit system
  def arch_64?
    node['kernel']['machine'] =~ /x86_64/ ? true : false
  end

  # Check to see if we are on a Windows machine
  def windows?
    platform_family?('windows') ? true : false
  end
end

Chef::Recipe.send(:include, Roblox)
Chef::Resource.send(:include, Roblox)
Chef::Provider.send(:include, Roblox)
