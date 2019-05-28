default['golang']['install_method'] = 'package'
# install latest version
default['golang']['version'] = nil
# SHA256 for .tar.gz files, needed for source and binary recipes
default['golang']['shasum'] = nil

# This attribute will likely not need to be modified
default['golang']['binary_base_url'] = 'https://dl.google.com/go'
