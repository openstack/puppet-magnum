Puppet::Type.type(:magnum_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/magnum/magnum.conf'
  end

end
