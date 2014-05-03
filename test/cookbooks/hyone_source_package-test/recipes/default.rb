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
  action [:create]
end

group _group do
  members [_user]
  action [:create]
end


case
when platform?('ubuntu')
  include_recipe 'apt'
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
