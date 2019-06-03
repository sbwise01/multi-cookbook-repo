# Installing Ruby on mac

## Install rbenv from brew
```
$ brew install rbenv
```

## Verify rbenv is setup correctly
```
$ which ruby
/Users/<username>/.rbenv/shims/ruby

$ which gem
/Users/<username>/.rbenv/shims/gem
```

## Download a newer version of ruby
Mac comes with an older version of ruby, at the time of this document 2.6.0 is the latest ruby that has been released

```
$ rbenv install 2.6.0
```

## Set ruby to use the newer version
```
$ rbenv shell 2.6.0
```

## Update your .zshrc or .bashrc
```
# Ruby
eval "$(rbenv init -)"
rbenv shell 2.6.0
```

## Completed
Now you can install gems, install newer versions of ruby, and switch versions of ruby as needed without messing with the apple permissions for the mac installed ruby
