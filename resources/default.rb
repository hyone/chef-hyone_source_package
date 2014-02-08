::Chef::Resource.send(:include, HyoneSourcePackage::Helper)

actions [:install]
default_action :install

attribute :name,              :kind_of => String, :name_attribute => true
attribute :version,           :kind_of => String
attribute :source_url,        :kind_of => String
attribute :source_checksum,   :kind_of => String
attribute :configure_options, :kind_of => String
attribute :prefix_base,       :kind_of => String
attribute :user,              :kind_of => String
attribute :group,             :kind_of => String


attr_accessor :exists

def long_name
  "#{name}-#{version}"
end


# define attribute's lazy default value

def group(arg = nil)
  if @group.nil?
    arg ||= user
  end

  set_or_return(:group, arg, :kind_of => String)
end

def prefix_base(arg = nil)
  if @prefix_base.nil?
    arg ||= case user
            when 'root' then '/usr/local'
            else ::File.join(user_home(user), 'local')
            end
  end

  set_or_return(:prefix_base, arg, :kind_of => String)
end

def prefix
  ::File.join(prefix_base, 'apps', long_name)
end
