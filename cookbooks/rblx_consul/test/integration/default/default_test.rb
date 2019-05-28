# InSpec test for recipe rblx_consul::default

# The InSpec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe file('/usr/local/bin/consul') do
  it { should be_file }
  it { should be_executable }
end

describe group('consul') do
  it { should exist }
end

describe user('consul') do
  it { should exist }
end

describe file('/etc/consul/consul.json') do
  its('mode') { should cmp '0640' }
  it { should be_file }
  it { should be_owned_by 'consul' }
  it { should be_grouped_into 'consul' }
end

describe service('consul') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
