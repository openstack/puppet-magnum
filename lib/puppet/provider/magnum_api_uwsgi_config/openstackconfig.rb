Puppet::Type.type(:magnum_api_uwsgi_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/magnum/magnum-api-uwsgi.ini'
  end

end
