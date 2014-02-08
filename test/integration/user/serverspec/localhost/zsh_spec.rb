require 'spec_helper'


_user    = 'hoge'
_group   = _user
_prefix  = "/home/#{_group}/local"
_version = '5.0.5'
_zsh     = ::File.join(_prefix, "apps/zsh-#{_version}/bin/zsh")
_alias   = ::File.join(_prefix, 'bin/zsh')

describe file(_zsh) do
  it { should be_file }
  it { should be_executable }
  it { should be_owned_by _user }
  it { should be_grouped_into _group }
end

describe file(_alias) do
  it { should be_file }
  it { should be_linked_to _zsh }
end
