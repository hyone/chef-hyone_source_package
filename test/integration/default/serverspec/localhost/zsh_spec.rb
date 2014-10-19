require 'spec_helper'


_prefix  = '/usr/local'
_version = '5.0.6'
_zsh     = ::File.join(_prefix, "apps/zsh-#{_version}/bin/zsh")
_alias   = ::File.join(_prefix, 'bin/zsh')

describe file(_zsh) do
  it { should be_file }
  it { should be_executable }
end

describe file(_alias) do
  it { should be_file }
  it { should be_linked_to _zsh }
end
