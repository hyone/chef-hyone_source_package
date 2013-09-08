package 'readline-devel'


hyone_source_package "zsh" do
  user 'root'
  version '5.0.2'
  source_url 'http://www.zsh.org/pub/zsh-5.0.2.tar.gz'
  source_checksum 'adc0c7881532419797713b7c503bcc5674c88f93a191e26f700b42c11a1a816e'
  configure_options '--without-tcsetpgrp'
end
