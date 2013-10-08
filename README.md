# hyone_source_package cookbook

Cookbook to install packages from source distribution

# Requirements

# Usage

```ruby
hyone_source_package "zsh" do
  user 'root'
  version '5.0.2'
  source_url 'http://www.zsh.org/pub/zsh-5.0.2.tar.gz'
  configure_options '--without-tcsetpgrp'
end
```

# Attributes

# Recipes

# Author

Author:: hyone
