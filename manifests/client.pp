# == Class: magnum::client
#
# Manages the magnum client package on systems
#
# === Parameters:
#
# [*package_ensure*]
#   (optional) The state of the package
#   Defaults to present
#
class magnum::client (
  $package_ensure = present
) {

  include ::magnum::params

  package { 'python2-magnumclient':
    ensure => $package_ensure,
    name   => $::magnum::params::client_package,
    tag    => 'openstack',
  }

}
