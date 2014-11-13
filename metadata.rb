name             'hyone_source_package'
maintainer       'hyone'
maintainer_email 'hyone.development@gmail.com'
license          'All rights reserved'
description      'Installs/Configures packages from source'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'
depends          'build-essential'

supports         'ubuntu', '>= 12.04'
supports         'centos', ">= 6.0"
