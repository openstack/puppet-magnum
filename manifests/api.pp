# == Class: magnum::api
#
# Setup and configure the Magnum API endpoint
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) Sets the ensure parameter for the package resource.
#   Defaults to 'present'
#
# [*enabled*]
#   (Optional) Define if the service should be enabled or not.
#   Defaults to true
#
# [*port*]
#   (Optional) The port for the Magnum API server.
#   Defaults to '9511'
#
# [*host*]
#   (Optional) The listen IP for the Magnum API server.
#   Defaults to '127.0.0.1'
#
# [*max_limit*]
#   (Optional) The maximum number of items returned in a single response
#   from a collection resource.
#   Defaults to '1000'
#
# [*sync_db*]
#   (Optional) Enable DB sync
#   Defaults to true
#
# [*auth_strategy*]
#   (optional) Type of authentication to be used.
#   Defaults to 'keystone'
#
class magnum::api(
  $package_ensure = 'present',
  $enabled        = true,
  $port           = '9511',
  $host           = '127.0.0.1',
  $max_limit      = '1000',
  $sync_db        = true,
  $auth_strategy  = 'keystone',
) {

  include ::magnum::params
  include ::magnum::policy

  if $sync_db {
    include ::magnum::db::sync
  }

  Magnum_config<||> ~> Service['magnum-api']
  Class['magnum::policy'] ~> Service['magnum-api']

  # Configure API conf
  magnum_config {
    'api/port' :      value => $port;
    'api/host' :      value => $host;
    'api/max_limit' : value => $max_limit;
  }

  # Install package
  if $::magnum::params::api_package {
    Package['magnum-api'] -> Class['magnum::policy']
    Package['magnum-api'] -> Service['magnum-api']
    package { 'magnum-api':
      ensure => $package_ensure,
      name   => $::magnum::params::api_package,
      tag    => ['openstack', 'magnum-package'],
    }
  }

  if $enabled {
    $ensure = 'running'
  } else {
    $ensure = 'stopped'
  }

  # Manage service
  service { 'magnum-api':
    ensure    => $ensure,
    name      => $::magnum::params::api_service,
    enable    => $enabled,
    hasstatus => true,
    tag       => ['magnum-service', 'magnum-db-sync-service'],
  }

  if $auth_strategy == 'keystone' {
    include ::magnum::keystone::authtoken
  }

}
