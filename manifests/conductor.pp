# == Class: magnum::conductor
#
# Manages magnum conductor package and service
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether to enable the magnum-conductor service
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to true
#
# [*package_ensure*]
#   (optional) The state of the magnum conductor package
#   Defaults to 'present'
#
# [*auth_strategy*]
#   (optional) Type of authentication to be used.
#   Defaults to 'keystone'
#
# [*workers*]
#   (optional) Number of conductor workers.
#   Defaults to $facts['os_workers']
#
# DEPRECATED PARAMETERS
#
# [*conductor_life_check_timeout*]
#   (optional) RPC timeout for the conductor liveness check that is
#    used for bay locking.
#    Defaults to undef
#
class magnum::conductor(
  Boolean $enabled              = true,
  Boolean $manage_service       = true,
  $package_ensure               = 'present',
  $auth_strategy                = 'keystone',
  $workers                      = $facts['os_workers'],
  # DEPRECATED PARAMETERS
  $conductor_life_check_timeout = undef,
) {

  include magnum::db
  include magnum::deps
  include magnum::params

  if $conductor_life_check_timeout != undef {
    warning("The conductor_life_check_timeout parameter has been deprecated \
and has no effect.")
  }

  # Install package
  package { 'magnum-conductor':
    ensure => $package_ensure,
    name   => $::magnum::params::conductor_package,
    tag    => ['openstack', 'magnum-package']
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    # Manage service
    service { 'magnum-conductor':
      ensure    => $service_ensure,
      name      => $::magnum::params::conductor_package,
      enable    => $enabled,
      hasstatus => true,
      tag       => 'magnum-service',
    }
  }

  magnum_config {
    'conductor/workers': value => $workers;
  }

  # Remove this and conductor_life_check_timeout after 2025.1 release
  magnum_config {
    'conductor/conductor_life_check_timeout': ensure => absent;
  }

  if $auth_strategy == 'keystone' {
    include magnum::keystone::keystone_auth
  }
}
