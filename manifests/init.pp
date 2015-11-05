# == Class: magnum
#
# magnum base package & configuration
#
class magnum {

  include ::magnum::params
  include ::magnum::policy
  include ::magnum::db

  package { 'magnum-common':
    ensure => 'present',
    name   => $::magnum::params::common_package_name,
    tag    => ['openstack', 'magnum-package'],
  }

}
