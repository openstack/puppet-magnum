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
class magnum(
  $package_ensure      = 'present',
  $notification_driver = $::os_service_default,
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

  magnum_config {
    'DEFAULT/rpc_backend' :                        value => 'rabbit';
    'oslo_messaging_rabbit/userid' :               value => $rabbit_userid;
    'oslo_messaging_rabbit/rabbit_password' :      value => $rabbit_password, secret => true;
    'oslo_messaging_rabbit/rabbit_virtual_host' :  value => $rabbit_virtual_host;
    'oslo_messaging_rabbit/rabbit_use_ssl' :       value => $rabbit_use_ssl;
    'oslo_messaging_rabbit/kombu_ssl_ca_certs' :   value => $kombu_ssl_ca_certs;
    'oslo_messaging_rabbit/kombu_ssl_certfile' :   value => $kombu_ssl_certfile;
    'oslo_messaging_rabbit/kombu_ssl_keyfile' :    value => $kombu_ssl_keyfile;
    'oslo_messaging_rabbit/kombu_ssl_version' :    value => $kombu_ssl_version;
  }

  if ! is_service_default($rabbit_hosts) and $rabbit_hosts {
    magnum_config { 'oslo_messaging_rabbit/rabbit_hosts':     value => join(any2array($rabbit_hosts), ',') }
  } else {
    magnum_config { 'oslo_messaging_rabbit/rabbit_host':      value => $rabbit_host }
    magnum_config { 'oslo_messaging_rabbit/rabbit_port':      value => $rabbit_port }
    magnum_config { 'oslo_messaging_rabbit/rabbit_hosts':     ensure => absent }
  }

  if !is_service_default($notification_driver) and $notification_driver {
    magnum_config {
      'DEFAULT/notification_driver': value => join(any2array($notification_driver), ',');
    }
  } else {
    magnum_config { 'DEFAULT/notification_driver': ensure => absent; }
  }

}
