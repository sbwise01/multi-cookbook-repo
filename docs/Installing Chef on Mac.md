# Installing Chef on Mac

## Install ChefDK
ChefDK is the Chef Development Kit, this contains the following:
* `chef-client` binary
* `chef` and `knife` command line tools
* Testing tools such as `kitchen`, `ChefSpec`, `Cookstyle`, and `Foodcritic`
* `InSpec`
* and pretty much everything else you need to author cookbooks

### Installing with homebrew
```
brew cask install chef/chef/chefdk
```

### Manual install
1. Navigate to [https://downloads.chef.io/chefdk#mac_os_x]()
2. Pick the MacOS version that you are using, and click download
3. This will download a DMG that will contain an installer, run the installer

## Install virtualbox
Virtualbox is a free and open source hosted hypervisor. Vagrant can use this and other VM platforms for testing cookbooks.

### Installing with homebrew
```
brew cask install virtualbox
```

### Manual install
1. Navigate to [https://www.virtualbox.org/]()
2. Click Downloads
3. Click `OS X hosts`
4. This will download a DMG that will contain an installer, run the installer

## Install Vagrant
Vagrant is a tool for building and managing virtual machines, this is used with kitchen to test cookbooks

### Installing with homebrew
```
brew cask install vagrant
brew cask install vagrant-manager
```

### Manual install
1. Navigate to [https://www.vagrantup.com/downloads.html]()
2. Click on `64-bit` under macOS
3. This will download a DMG that will contain an installer, run the installer
4. Navigate to [https://github.com/lanayotech/vagrant-manager/releases]()
5. Click on `vagrant-manager-{version}.dmg`
6. This will download a DMG that contains an application that you drag to your applications folder 
