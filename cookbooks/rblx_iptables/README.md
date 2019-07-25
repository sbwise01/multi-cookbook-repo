Description
===========

Sets up iptables and maintains firewall rules.

Rules are applied at the end of a successful chef run.  If the chef run fails, no changes in iptables rules will be made. 

Requirements
============

## Platform:

* Ubuntu/Debian
* RHEL/CentOS

Recipes
=======

default
-------

The default recipe will install iptables and manage iptables rules.

Definitions
===========

iptables\_rule
--------------

The definition defines an iptable rule that will be applied at the end of the chef run. See __Examples__ below.

Examples
--------

To enable port 80, e.g. in an `httpd` cookbook recipe, pass the following to the `iptables_rule` resource:
```ruby
    iptables_rule 'http' do
        dport 80
        protocol :tcp
        jump :accept
    end
```
Attributes
==========

Iptables rules can also be defined via attributes.

Set the `node['rblx_iptables']['rules']` attribute to have these rules applied at the end of the chef run. See __Examples__ below.

Examples
--------

To enable port 80, e.g. for an `httpd` listener, set the `node['rblx_iptables']['rules']` attribute:
```ruby
    override['rblx_iptables']['filter']['HTTP'] = {
        protocol: 'tcp',
        dport: 80,
        jump: 'accept'
    }
```
Here is an example OpenVPN setup that shows how to set rules on the `nat` table and `filter` table:
```ruby
    override['rblx_iptables']['nat']['Setup NAT'] = {
        chain: 'postrouting',
        source: '192.168.235.0/24',
        output_interface: 'eth0',
        jump: 'masquerade'
    }
    
    override['rblx_iptables']['filter'] = {
        'Port 1194': { # SSL VPN
            protocol: 'udp',
            input_interface: 'eth0',
            dport: 1194,
            options: '--state NEW -m udp',
            jump: 'accept'
        },
        'Accept on tun': {
            input_interface: 'tun+',
            jump: 'accept'
        },
        'Forward from tun': {
            chain: 'forward',
            input_interface: 'tun+',
            jump: 'accept'
        },
        'Accept related on tun': {
            chain: 'forward',
            input_interface: 'tun+',
            output_interface: 'eth0',
            jump: 'accept',
            options: '-m state --state RELATED,ESTABLISHED'
        },
        'Accept related on eth0': {
            chain: 'forward',
            input_interface: 'eth0',
            output_interface: 'tun+',
            jump: 'accept',
            options: '-m state --state RELATED,ESTABLISHED'
        },
        'Forward to run': {
            chain: 'output',
            output_interface: 'tun+',
            jump: 'accept'
        }
    }
```
Only `nat` and `filter` chains are supported.

Sysctl Tuning
==================

The following sysctl settings should be tuned on systems that expect to handle a high number of connections:

```bash
net.nf_conntrack_max
net.netfilter.nf_conntrack_max
```


License and Maintainer
==================

Maintainer: Cloud Services <cloudsvcs@roblox.com>

Copyright: 2018, Roblox, Inc.

All rights reserved
