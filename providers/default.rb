require 'pathname'
require 'uri'

::Chef::Provider.send(:include, HyoneSourcePackage::Helper)


use_inline_resources if defined? use_inline_resources

action :install do
  if current_resource.exists
    Chef::Log.info "#{current_resource.name} already exists - nothing to do."
  else
    converge_by("Install #{new_resource.name} #{new_resource.version} to #{new_resource.prefix_base}") do
      install_from_source
    end
  end
end


def load_current_resource
  @current_resource = Chef::Resource::HyoneSourcePackage.new(new_resource.name)
  @current_resource.version(new_resource.version)
  @current_resource.source_url(new_resource.source_url)
  @current_resource.source_checksum(new_resource.source_checksum)
  @current_resource.configure_options(new_resource.configure_options)
  @current_resource.prefix_base(new_resource.prefix_base)
  @current_resource.user(new_resource.user)
  @current_resource.group(new_resource.group)

  if ::File.exists? @current_resource.prefix
    @current_resource.exists = true
  end
end


private

def install_from_source
  _cache_path = ::Chef::Config[:file_cache_path]
  _bindir     = ::File.join(new_resource.prefix_base, 'bin')
  _workdir    = ::File.join(_cache_path, new_resource.long_name)

  run_context.include_recipe 'build-essential'

  workdir_resource = directory _workdir do
    action :create
    owner new_resource.user
    group new_resource.group
    recursive true
  end

  # get and extract source distribution
  prepare_source_distribution(_workdir)

  # compile and install
  bash "install #{new_resource.long_name} from source" do
    user  new_resource.user
    group new_resource.group
    code <<-EOL
      cd #{_workdir};
      cd `ls -d */ | head -1`
      ./configure --prefix #{new_resource.prefix} #{new_resource.configure_options}
      make
      make install
    EOL
    creates new_resource.prefix
    notifies :delete, workdir_resource
  end

  link_to_bin(_bindir)
end


def prepare_source_distribution(_workdir)
  _filename = ::File.basename URI(new_resource.source_url).path
  _path     = ::File.join(_workdir, _filename)

  archivefile =
    remote_file _path do
      source   new_resource.source_url
      checksum new_resource.source_checksum
      owner new_resource.user
      group new_resource.group
      action :create_if_missing
    end

  package 'tar'

  _extract_option = case
    when _filename.end_with?('gz')  then 'zxvf'
    when _filename.end_with?('bz2') then 'jxvf'
  end

  bash "extract #{_path}" do
    user  new_resource.user
    group new_resource.group
    cwd _workdir
    code <<-EOC
      tar #{_extract_option} #{_path}
    EOC
    not_if "ls -d */ | grep #{new_resource.name}"
  end
end


def link_to_bin(_bindir)
  directory _bindir do
    action :create
    owner new_resource.user
    group new_resource.group
    mode 0755
    recursive true
  end

  ruby_block "link #{new_resource.name} to bin directory" do
    block do
      (Pathname(new_resource.prefix) + 'bin').each_child.select {|x| x.file? }.each do |dist|
        link_resource = Chef::Resource::Link.new(::File.join(_bindir, dist.basename), run_context)
        link_resource.to dist.to_s
        link_resource.owner new_resource.user  if new_resource.user
        link_resource.group new_resource.group if new_resource.group
        link_resource.run_action(:create)
      end
    end
    action :create
  end
end
