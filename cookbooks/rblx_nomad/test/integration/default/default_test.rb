# InSpec test for recipe rblx_nomad::default

# The InSpec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe file('/usr/local/bin/nomad') do
  it { should be_file }
  it { should be_executable }
end

describe group('nomad') do
  it { should exist }
end

describe user('nomad') do
  it { should exist }
end

describe service('nomad') do
  it { should be_installed }
  it { should be_enabled }
end
