module HyoneSourcePackage
  module Helper
    def get_home(user, run_context)
      # make sure user information is latest
      ohai = Chef::Resource::Ohai.new('reload passwd', run_context)
      ohai.plugin('current_user')
      ohai.run_action(:reload)

      run_context.node['etc']['passwd'].fetch(user, {}).fetch('dir', nil)
    end
  end
end
