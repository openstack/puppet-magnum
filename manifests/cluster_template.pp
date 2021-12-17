# == Class: magnum::cluster_template
#
# Setup magnum cluster_template.
#
# === Parameters
#
# [*kubernetes_allowed_network_drivers*]
#   (optional) Allowed network drivers for kubernetes cluster-templates.
#   Defaults to $::os_service_default
#
# [*kubernetes_default_network_driver*]
#   (optional) Default network driver for kubernetes.
#   Defaults to $::os_service_default
#
class magnum::cluster_template (
  $kubernetes_allowed_network_drivers = $::os_service_default,
  $kubernetes_default_network_driver  = $::os_service_default,
) {

  include magnum::deps

  magnum_config {
    'cluster_template/kubernetes_allowed_network_drivers': value => join(any2array($kubernetes_allowed_network_drivers), ',');
    'cluster_template/kubernetes_default_network_driver':  value => $kubernetes_default_network_driver;
  }
}
