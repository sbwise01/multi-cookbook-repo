# Description

Installs/Configures Nomad

# Requirements


## Chef Client:

* chef (>= 14.0) ()

## Platform:

* ubuntu (= 18.04)

## Cookbooks:

* rblx_utils
* docker

# Attributes

* `node['rblx_nomad']['service_user']` -  Defaults to `nomad`.
* `node['rblx_nomad']['service_group']` -  Defaults to `nomad`.
* `node['rblx_nomad']['release_url']` -  Defaults to `https://releases.hashicorp.com/nomad`.
* `node['rblx_nomad']['version']` -  Defaults to `0.8.7`.
* `node['rblx_nomad']['docker']['version']` -  Defaults to `18.09.1`.

# Recipes

* rblx_nomad::configure_nomad
* rblx_nomad::default
* rblx_nomad::install_debian
* rblx_nomad::install_docker
* rblx_nomad::install_nomad_linux
* rblx_nomad::service_nomad_systemd

# License and Maintainer

Maintainer:: Erin Reed (<ereed@roblox.com>)

Source:: https://github.com/Roblox/rblx_chef_infrastructure/tree/master/cookbooks/rblx_nomad

Issues:: https://github.com/Roblox/rblx_chef_infrastructure/issues

License:: All Rights Reserved
