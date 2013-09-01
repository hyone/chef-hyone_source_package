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
