# frozen_string_literal: true

%w(unit lint syntax).each do |phase|
  # TODO: This works on Linux/Unix. Not Windows.
  command = "HOME=/home/vagrant delivery job verify #{phase}" +
    ' --server localhost --ent test --org kitchen'
  execute command do
    cwd '/tmp/repo-data'
    user 'vagrant'
    environment('GIT_DISCOVERY_ACROSS_FILESYSTEM' => '1')
  end
end
