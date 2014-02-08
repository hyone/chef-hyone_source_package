# hyone_source_package cookbook

Cookbook to install packages from source distribution

# Requirements

# LWRP

```ruby
hyone_source_package 'zsh' do
  user _user
  version '5.0.5'
  source_url "http://downloads.sourceforge.net/project/zsh/zsh/5.0.5/zsh-5.0.5.tar.gz"
  prefix_base '/usr/local'
  configure_options '--without-tcsetpgrp'
end
```

- package is installed to `"#{prefix_base}/apps/#{package}-#{version}"`
- files in `'bin'` directory is linked into `"#{prefix_base}/bin"`
- `prefix_base` default value is if `user` is `'root'` then `'/usr/local'` else `"#{ENV['HOME']}/local"`

# Attributes

# Recipes

# Author

Author:: hyone
