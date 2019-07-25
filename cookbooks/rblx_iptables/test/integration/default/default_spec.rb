if os.family == 'redhat'
  service_name = 'iptables'
  sysconfig_path = '/etc/sysconfig/iptables'
elsif os.family == 'debian'
  service_name = 'netfilter-persistent'
  sysconfig_path = '/etc/iptables/rules.v4'
else
  fail("Unsupported OS family: #{os.family}")
end

describe service(service_name) do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# rubocop:disable Style/RegexpLiteral

describe file(sysconfig_path) do
  it { should exist }
  its('content') { should match %r{:INPUT ACCEPT \[0:0]} }
  its('content') { should match %r{:FORWARD ACCEPT \[0:0]} }
  its('content') { should match %r{:OUTPUT ACCEPT \[0:0]} }
  its('content') { should match %r{-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT} } # rubocop:disable Metrics/LineLength
  its('content') { should match %r{-A INPUT -p icmp -j ACCEPT} }
  its('content') { should match %r{-A INPUT -i lo -j ACCEPT} }
  its('content') { should match %r{# Non-default section} }
  its('content') { should match %r{--append INPUT --protocol tcp --destination-port 22 --jump ACCEPT} } # rubocop:disable Metrics/LineLength
  its('content') { should match %r{--append INPUT --protocol tcp --destination-port 80 --jump ACCEPT} } # rubocop:disable Metrics/LineLength
  its('content') { should match %r{# End non-default section} }
  its('content') { should match %r{-A INPUT -j REJECT --reject-with icmp-port-unreachable} } # rubocop:disable Metrics/LineLength
  its('content') { should match %r{-A FORWARD -j REJECT --reject-with icmp-host-prohibited} } # rubocop:disable Metrics/LineLength
  its('content') { should match %r{COMMIT} }
end

describe command('iptables --list-rules') do
  its('stdout') { should match %r{-P INPUT ACCEPT} }
  its('stdout') { should match %r{-P FORWARD ACCEPT} }
  its('stdout') { should match %r{-P OUTPUT ACCEPT} }
  its('stdout') { should match %r{-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT} } # rubocop:disable Metrics/LineLength
  its('stdout') { should match %r{-A INPUT -p icmp -j ACCEPT} }
  its('stdout') { should match %r{-A INPUT -i lo -j ACCEPT} }
  its('stdout') { should match %r{-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT} } # rubocop:disable Metrics/LineLength
  its('stdout') { should match %r{-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT} } # rubocop:disable Metrics/LineLength
  its('stdout') { should match %r{-A INPUT -j REJECT --reject-with icmp-port-unreachable} } # rubocop:disable Metrics/LineLength
  its('stdout') { should match %r{-A FORWARD -j REJECT --reject-with icmp-host-prohibited} } # rubocop:disable Metrics/LineLength
end

# rubocop:enable Style/RegexpLiteral
