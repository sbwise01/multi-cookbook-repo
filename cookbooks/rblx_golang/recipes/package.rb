#
# Cookbook:: rblx_golang
# Recipe:: package
#
# Copyright:: 2019, Roblox, All Rights Reserved.

require 'mixlib/shellout'

version = node['golang']['version']

# EL7.6 removed Golang from the base repos entirely.
# Prior to that, a package exists in the repos - check to see if matches
# the version we want (or nil)
if node['platform_family'] == 'rhel'
  if !version.nil?
    cmd = Mixlib::ShellOut.new(
      'yum --showduplicates list golang | ' +
      "awk '/^golang/ { print substr($2, 0, index($2, \"-\")-1) }'"
    )
    cmd.run_command
    package 'epel-release' do
      not_if cmd.stdout.include?(version)
    end
  else
    package 'epel-release' do
    end
  end
end

# Debian uses x.y version numbers instead of x.y.z - if we got an x.y.z we will
# never be able to find a matching version
if node['platform_family'] == 'debian' && !version.nil?
  unless version =~ /\d\.\d+/
    Chef::Log.fatal(
      'rblx_golang: Version for Debian must be in the form x.y (eg 1.11).' +
      " Got '#{version}'"
    )
    fail
  end

  # The Golang Wiki suggests using one of two PPAs in the Wiki
  # <https://github.com/golang/go/wiki/Ubuntu>
  # They provide slightly different versions of Golang - we'll try both
  cmd = Mixlib::ShellOut.new(
    'apt-cache madison golang | ' +
    "awk '/golang/ { print substr($3, index($3, \":\")+1," +
    " index($3, \"~\")-3) }'"
  )
  cmd.run_command
  apt_repository 'golang-gophers' do
    uri          'ppa:gophers/archive'
    only_if node['platform'] == 'ubuntu'
    not_if cmd.stdout.include?(version)
  end

  apt_repository 'golang-backports' do
    uri          'ppa:longsleep/golang-backports'
    only_if node['platform'] == 'ubuntu'
    not_if cmd.stdout.include?(version)
    notifies :remove, 'apt_repository[golang-gophers]', :immediately
  end
end

package 'golang' do
  case node['platform_family']
  when 'debian'
    package_name 'golang-go'
  when 'rhel'
    package_name 'golang'
  end
  version version unless version.nil?
end
