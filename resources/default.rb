::Chef::Resource.send(:include, HyoneSourcePackage::Helper)

actions [:install]
default_action :install

attribute :name,              :kind_of => String, :name_attribute => true
attribute :version,           :kind_of => String
attribute :source_url,        :kind_of => String
attribute :source_checksum,   :kind_of => String
attribute :configure_options, :kind_of => String
attribute :prefix,            :kind_of => String
attribute :user,              :kind_of => String
attribute :group,             :kind_of => String
attribute :home,              :kind_of => String


attr_accessor :exists

def long_name
  "#{name}-#{version}"
end


# define attribute's lazy default value

def group(arg =  nil)
  if @group.nil?
    arg ||= user
  end

  set_or_return(:group, arg, :kind_of => String)
end

def home(arg = nil)
  if @home.nil?
    arg ||= user_home(user)
  end

  set_or_return(:home, arg, :kind_of => String)
end

def prefix(arg = nil)
  if @prefix.nil?
    arg ||= ::File.join(home, 'local/apps', long_name)
  end

  set_or_return(:prefix, arg, :kind_of => String)
end
