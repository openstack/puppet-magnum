# == Class: magnum::drivers
#
# Manages the magnum drivers section
#
# === Parameters:
#
# [*verify_ca*]
#   (optional) Indicates whether the cluster nodes
#   validate the Certificate Authority
#   Defaults to $facts['os_service_default']
#
# [*openstack_ca_file*]
#   (optional) Path to the OpenStack CA-bundle file to
#   pass and install in all cluster nodes.
#   Defaults to $facts['os_service_default']
#
# [*disabled_drivers*]
#   (optional) Array of disabled driver entry points.
#   Defaults to $facts['os_service_default']
#
# [*enabled_beta_drivers*]
#   (optional) Array of beta drivers to enable.
#   Defaults to $facts['os_service_default']
#
class magnum::drivers (
  Variant[Boolean, Openstacklib::ServiceDefault]              $verify_ca             = $facts['os_service_default'],
  Variant[Stdlib::Absolutepath, Openstacklib::ServiceDefault] $openstack_ca_file     = $facts['os_service_default'],
  Variant[Array, Openstacklib::ServiceDefault]                $disabled_drivers      = $facts['os_service_default'],
  Variant[Array, Openstacklib::ServiceDefault]                $enabled_beta_drivers  = $facts['os_service_default'],
) {

  include magnum::deps

  magnum_config {
    'drivers/verify_ca':            value => $verify_ca;
    'drivers/openstack_ca_file':    value => $openstack_ca_file;
    'drivers/disabled_drivers':     value => join(any2array($disabled_drivers), ',');
    'drivers/enabled_beta_drivers': value => join(any2array($enabled_beta_drivers), ',');
  }
}
