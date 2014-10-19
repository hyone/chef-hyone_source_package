_attr  = node.fetch('main', {})
_user  = _attr.fetch('user', 'root')
_group = _attr.fetch('group', _user)
_home  = _user == 'root' ? '/root' : "/home/#{_user}"


# user and group
user _user do
  supports manage_home: true
  # we must explicitly specify home directory,
  # to avoid problem not to create home directory
  # dispite that 'manage_home: true' on ubuntu
  home  _home
  shell '/bin/bash'
  action [:nothing]
end.run_action(:create)

group _group do
  members [_user]
  action [:nothing]
end.run_action(:create)


case
when platform?('ubuntu')
  include_recipe 'apt'
end

# Generate locales to avoid warnings like:
# 'bash: warning: setlocale: LC_ALL: cannot change locale (ja_JP.UTF-8)'
case
when platform?('centos')
  execute 'generate locale' do
    command 'localedef -f UTF-8 -i ja_JP /usr/lib/locale/ja_JP.UTF-8'
    action [:run]
  end
when platform?('ubuntu')
  execute 'locale-gen' do
    command 'locale-gen ja_JP.UTF-8'
    action [:run]
  end
end

case node['platform_family']
when 'rhel', 'fedora'
  %w[readline-devel]
when 'debian'
  %w[libreadline-dev]
end.each do |pkg|
  package pkg do
    action [:install]
  end
end

hyone_source_package 'zsh' do
  user _user
  version '5.0.5'
  source_url "http://downloads.sourceforge.net/project/zsh/zsh/5.0.5/zsh-5.0.5.tar.gz"
  configure_options '--without-tcsetpgrp'
end
