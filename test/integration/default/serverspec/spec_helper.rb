require 'serverspec'

include SpecInfra::Helper::Exec
include SpecInfra::Helper::DetectOS

RSpec.configure do |c|
  c.os = backend(Serverspec::Commands::Base).check_os
end
