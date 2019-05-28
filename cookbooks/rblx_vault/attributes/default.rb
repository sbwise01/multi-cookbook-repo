#
# Cookbook:: rblx_vault
# Recipe:: default
#
# Copyright:: 2019, Roblox Inc., All Rights Reserved.

default['hashicorp-vault']['install_method'] = 'binary'

default['hashicorp-vault']['service_name'] = 'vault'
default['hashicorp-vault']['service_user'] = 'vault'
default['hashicorp-vault']['service_group'] = 'vault'

default['hashicorp-vault']['version'] = '1.0.0'

default['hashicorp-vault']['config_path'] = '/etc/vault'
default['hashicorp-vault']['config_file'] = 'vault.json'
default['hashicorp-vault']['log_level'] = 'info'

default['hashicorp-vault']['config']['address'] = '127.0.0.1:8200'
default['hashicorp-vault']['config']['tls_cert_file'] =
  '/etc/vault/ssl/certs/vault.crt'
default['hashicorp-vault']['config']['tls_key_file'] =
  '/etc/vault/ssl/private/vault.key'
