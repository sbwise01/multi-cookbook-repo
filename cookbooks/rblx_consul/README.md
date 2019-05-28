# Consul Cookbook

Cookbook which installs and configures [Consul][0].

Consul is a tool for discovering and configuring services within your
infrastructure. This is a cookbook which takes a
simplified approach to configuring and installing
Consul. Additionally, it provides Chef primitives for more advanced
configuration.

## Basic Usage
For most infrastructure we suggest first starting with the default
recipe. This installs and configures Consul from the latest supported
release.

This cookbook provides node attributes which are used to fine tune
the default recipe which installs and configures Consul. These values
are passed directly into the custom configuration resource which is exposed
for more advanced configuration.

Out of the box the following platforms are certified to work and are
tested using our [Test Kitchen][1] configuration. Additional platforms
_may_ work, but your mileage may vary.

- RHEL/CentOS 6.X, 7.X
- Ubuntu 16.04, 18.04

### Client
Out of the box the default recipe installs and configures the Consul
agent to run as a service in _client mode_. The intent here is that
your infrastructure already has a [quorum of servers][2]. In order
to configure Consul to connect to your cluster you would supply an
array of addresses for the Consul agent to join:
```ruby
node.default['consul']['config']['start_join'] = %w{c1.internal.corporate.com c2.internal.corporate.com c3.internal.corporate.com}
```

### Server
This cookbook is designed to allow for the flexibility to bootstrap a
new cluster. The best way to do this is through the use of a
wrapper cookbook which tunes specific node attributes for a
production server deployment.

## Advanced Usage
As explained above this cookbook provides Chef primitives to further manage
the install and configuration of Consul.
These primitives are what is used in the default recipe,
and should be used in your own wrapper cookbooks for more
advanced configurations.

### Security
The default recipe makes the Consul configuration writable by the consul service
user to avoid breaking existing implementations. You can make this more secure
by setting the `node['consul']['service_user']` attribute to `root`, or set
the `service_user` property of `consul` explicitly:

```ruby
# attributes file
default['consul']['service_user'] = 'root'
```

[0]: http://consul.io
[1]: https://github.com/test-kitchen/test-kitchen
[2]: https://en.wikipedia.org/wiki/Quorum_(distributed_computing)
