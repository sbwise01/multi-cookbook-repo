#
# Cookbook:: rblx_nomad
# Recipe:: install_nomad
#
# Copyright:: 2019, Roblox, All Rights Reserved.

nomad_user = node['rblx_nomad']['service_user']
nomad_group = node['rblx_nomad']['service_group']

nomad_version = node['rblx_nomad']['version']
nomad_binary = nomad_binary_name(node, nomad_version)
nomad_validation = nomad_validation_name(nomad_version)
nomad_validation_sig = nomad_validation_sig_name(nomad_version)
nomad_download_url = "#{node['rblx_nomad']['release_url']}/#{nomad_version}"
nomad_local_path = '/opt/nomad'

# Create nomad user and group
# ---------------------------

# Create nomad group
group nomad_group do
  action :create
end

# Create nomad user
user nomad_user do
  comment 'Nomad User - created by Chef'
  gid nomad_group
  shell '/bin/false'
  system true
  home '/etc/nomad.d'
end

# Prep nomad directory
# --------------------

# Create nomad binary directory
directory nomad_local_path do
  owner nomad_user
  group nomad_group
  action :create
end

# Download and install hashicorp gpg key for validation
# -----------------------------------------------------

# Copy Hashicorp public gpg key to temp directory
cookbook_file 'hashicorp_gpg_key' do
  source 'hashicorp.asc'
  path "#{Chef::Config['file_cache_path']}/hashicorp.asc"
  notifies :run, 'bash[install_gpg_key]', :immediately
end

# Install Hashicorp gpg key for validation
bash 'install_gpg_key' do
  cwd Chef::Config['file_cache_path']
  code <<-BASH
    gpg --import hashicorp.asc
  BASH
  action :nothing
end

# Get nomad validation files and validate them using the gpg key
# --------------------------------------------------------------

# Download nomad hash
remote_file 'nomad_sha256sums' do
  source "#{nomad_download_url}/#{nomad_validation}"
  path "#{Chef::Config['file_cache_path']}/#{nomad_validation}"
  action :nothing
end

# Download nomad signature file
remote_file 'nomad_sha256sums.sig' do
  source "#{nomad_download_url}/#{nomad_validation_sig}"
  path "#{Chef::Config['file_cache_path']}/#{nomad_validation_sig}"
  action :nothing
end

# Validate the signature matches signed Hasicorp key
bash 'validate_nomad_signatures' do
  cwd Chef::Config['file_cache_path']
  code <<-BASH
    gpg --verify #{nomad_validation_sig} #{nomad_validation}
    rm #{nomad_validation_sig}
  BASH
  action :nothing
end

# Download nomad
# --------------

# Create versioned nomad directory for binary
directory "#{nomad_local_path}/#{nomad_version}" do
  owner nomad_user
  group nomad_group
  action :create
end

# Download the nomad archive from Hashicorp
remote_file 'nomad_archive' do
  not_if { File.exist?("#{nomad_local_path}/#{nomad_version}/nomad") }
  notifies :create_if_missing, 'remote_file[nomad_sha256sums]', :before
  notifies :create_if_missing, 'remote_file[nomad_sha256sums.sig]', :before
  notifies :run, 'bash[validate_nomad_signatures]', :before
  source "#{nomad_download_url}/#{nomad_binary}"
  path "#{Chef::Config['file_cache_path']}/#{nomad_binary}"
  notifies :run, 'bash[validate_nomad_binary]', :immediately
  notifies :run, 'bash[install_nomad_binary]', :immediately
  notifies :run, 'bash[enable_auto_complete]', :immediately
end

# Validate the SHA256 signature on the download
bash 'validate_nomad_binary' do
  cwd Chef::Config['file_cache_path']
  code <<-BASH
    sha256sum -c #{nomad_validation} --ignore-missing
    rm #{nomad_validation}
  BASH
  action :nothing
end

# Extracts and copies the nomad binary then deletes the archive
bash 'install_nomad_binary' do
  cwd Chef::Config['file_cache_path']
  code <<-BASH
    unzip #{nomad_binary}
    mv nomad #{nomad_local_path}/#{nomad_version}/nomad
    rm #{nomad_binary}
  BASH
  action :nothing
end

# Enables auto complete features on the Nomad binary
bash 'enable_auto_complete' do
  code <<-BASH
    nomad -autocomplete-install
    complete -C /usr/local/bin/nomad nomad
  BASH
  action :nothing
end

# Link nomad binary to the bin directory
link '/usr/local/bin/nomad' do
  to "#{nomad_local_path}/#{nomad_version}/nomad"
  action :create
end
