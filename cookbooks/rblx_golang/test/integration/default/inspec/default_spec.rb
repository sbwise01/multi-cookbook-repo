describe file('/usr/bin/go') do
  it { should be_file }
  it { should be_executable }
end

describe file('/tmp/testfiles/hello_world/hello_world.go') do
  it { should be_file }
end

describe command('/usr/bin/go run /tmp/testfiles/hello_world/hello_world.go') do
  its('stdout') { should eq "Hello World!\n" }
  its('exit_status') { should eq 0 }
end
