# == Class: magnum::api
#
# Setup and configure the Magnum API endpoint
#
# === Parameters
#
# [*admin_password*]
#  (Required) The password to set for the magnum user in keystone.
#
# [*package_ensure*]
#  (Optional) Sets the ensure parameter for the package resource.
#  Defaults to 'present'
#
# [*enabled*]
#  (Optional) Define if the service should be enabled or not.
#  Defaults to true
#
# [*port*]
#  (Optional) The port for the Magnum API server.
#  Defaults to '9511'
#
# [*host*]
#  (Optional) The listen IP for the Magnum API server.
#  Defaults to '127.0.0.1'
#
# [*max_limit*]
#  (Optional) The maximum number of items returned in a single response
#  from a collection resource.
#  Defaults to '1000'
#
# [*auth_uri*]
#  (Optional) Complete public identity API endpoint.
#  Defaults to 'http://127.0.0.1:5000/'
#
# [*identity_uri*]
#  (Optional) Complete admin identity API endpoint.
#  Defaults to 'http://127.0.0.1:35357/'
#
# [*auth_version*]
#  (Optional) API version of the admin identity API endpoint. For example,
#  use 'v3' for the keystone version 3 API.
#  Defaults to false
#
# [*sync_db*]
#  (Optional) Enable DB sync
#  Defaults to true
#
# [*admin_tenant_name*]
#  (Optional) The name of the tenant to create in keystone for use by Magnum services.
#  Defaults to 'services'
#
# [*admin_user*]
#  (Optional) The name of the user to create in keystone for use by Magnum services.
#  Defaults to 'magnum'
#

class magnum::api(
  $admin_password,
  $package_ensure    = 'present',
  $enabled           = true,
  $port              = '9511',
  $host              = '127.0.0.1',
  $max_limit         = '1000',
  $auth_uri          = 'http://127.0.0.1:5000/',
  $identity_uri      = 'http://127.0.0.1:35357/',
  $auth_version      = false,
  $sync_db           = true,
  $admin_tenant_name = 'services',
  $admin_user        = 'magnum',
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

  if $auth_version {
    magnum_config { 'keystone_authtoken/auth_version' : value => $auth_version; }
  } else {
    magnum_config { 'keystone_authtoken/auth_version' : ensure => absent; }
  }

  magnum_config {
    'keystone_authtoken/auth_uri' :          value => $auth_uri;
    'keystone_authtoken/identity_uri' :      value => $identity_uri;
    'keystone_authtoken/admin_tenant_name' : value => $admin_tenant_name;
    'keystone_authtoken/admin_user' :        value => $admin_user;
    'keystone_authtoken/admin_password' :    value => $admin_password, secret => true;
  }

}
