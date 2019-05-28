# rblx_vault cookbook

Cookbook for installing and configuring [Hashicorp Vault][1].

Vault is a tool, which when used properly, manages secure manage to
secrets for your infrastructure.

## Platform Support
The following platforms have been certified with integration tests
using Test Kitchen:

- CentOS (RHEL) 6.X, 7.X
- Ubuntu 16.04, 18.04

## Basic Usage
This cookbook was designed from the ground up to make it dead simple
to install and configure the [Vault daemon][0] as a system service
using Chef.

This cookbook provides
[node attributes](attributes/default.rb) which can be used to fine
tune the default recipe which installs and configures Vault. The
values from these node attributes are fed directly into the custom
configuration resource.

This cookbook can be added to the run list of all of the nodes that
you want to be part of the cluster.

[0]: https://www.vaultproject.io
