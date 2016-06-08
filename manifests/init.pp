# == Class: magnum
#
# magnum base package & configuration
#
# === Parameters
#
# [*package_ensure*]
#  (Optional) Ensure state for package
#  Defaults to 'present'
#
# [*notification_driver*]
#  (Optional) Notification driver to use
#  Defaults to $::os_service_default
#
# [*rpc_backend*]
#  (optional) The rpc backend implementation to use, can be:
#  rabbit (for rabbitmq)
#  Defaults to 'rabbit'
#
# [*rabbit_host*]
#  (Optional) Host for rabbit server
#  Defaults to $::os_service_default
#
# [*rabbit_hosts*]
#  (Optional) List of clustered rabbit servers
#  Defaults to $::os_service_default
#
# [*rabbit_port*]
#  (Optional) Port for rabbit server
#  Defaults to $::os_service_default
#
# [*rabbit_userid*]
#  (Optional) Username used to connecting to rabbit
#  Defaults to $::os_service_default
#
# [*rabbit_virtual_host*]
#  (Optional) Virtual host for rabbit server
#  Defaults to $::os_service_default
#
# [*rabbit_password*]
#  (Optional) Password used to connect to rabbit
#  Defaults to $::os_service_default
#
# [*rabbit_use_ssl*]
#  (Optional) Connect over SSL for rabbit
#  Defaults to $::os_service_default
#
# [*kombu_ssl_ca_certs*]
#  (Optional) SSL certification authority file (valid only if rabbit SSL is enabled)
#  Defaults to $::os_service_default
#
# [*kombu_ssl_certfile*]
#  (Optional) SSL cert file (valid only if rabbit SSL is enabled)
#  Defaults to $::os_service_default
#
# [*kombu_ssl_keyfile*]
#  (Optional) SSL key file (valid only if rabbit SSL is enabled)
#  Defaults to $::os_service_default
#
# [*kombu_ssl_version*]
#  (Optional) SSL version to use (valid only if rabbit SSL is enabled).
#  Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be available
#  on some distributions.
#  Defaults to $::os_service_default
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the magnum config.
#   Defaults to false.
#
class magnum(
  $package_ensure      = 'present',
  $notification_driver = $::os_service_default,
  $rpc_backend         = 'rabbit',
  $rabbit_host         = $::os_service_default,
  $rabbit_hosts        = $::os_service_default,
  $rabbit_port         = $::os_service_default,
  $rabbit_userid       = $::os_service_default,
  $rabbit_virtual_host = $::os_service_default,
  $rabbit_password     = $::os_service_default,
  $rabbit_use_ssl      = $::os_service_default,
  $kombu_ssl_ca_certs  = $::os_service_default,
  $kombu_ssl_certfile  = $::os_service_default,
  $kombu_ssl_keyfile   = $::os_service_default,
  $kombu_ssl_version   = $::os_service_default,
  $purge_config        = false,
) {

  include ::magnum::params
  include ::magnum::logging
  include ::magnum::policy
  include ::magnum::db

  package { 'magnum-common':
    ensure => $package_ensure,
    name   => $::magnum::params::common_package,
    tag    => ['openstack', 'magnum-package'],
  }

  resources { 'magnum_config':
    purge => $purge_config,
  }

  if $rpc_backend == 'rabbit' {

    if ! $rabbit_password {
      fail('Please specify a rabbit_password parameter.')
    }

    oslo::messaging::rabbit { 'magnum_config':
      rabbit_userid       => $rabbit_userid,
      rabbit_password     => $rabbit_password,
      rabbit_virtual_host => $rabbit_virtual_host,
      rabbit_host         => $rabbit_host,
      rabbit_port         => $rabbit_port,
      rabbit_hosts        => $rabbit_hosts,
      rabbit_use_ssl      => $rabbit_use_ssl,
      kombu_ssl_version   => $kombu_ssl_version,
      kombu_ssl_keyfile   => $kombu_ssl_keyfile,
      kombu_ssl_certfile  => $kombu_ssl_certfile,
      kombu_ssl_ca_certs  => $kombu_ssl_ca_certs,
    }
  } else {
    magnum_config { 'DEFAULT/rpc_backend': value => $rpc_backend }
  }

  oslo::messaging::notifications { 'magnum_config':
    driver => $notification_driver
  }

}
