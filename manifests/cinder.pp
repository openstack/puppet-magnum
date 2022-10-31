# == Class: magnum::cinder
#
# Manages the magnum cinder config
#
# === Parameters:
#
# [*default_docker_volume_type*]
#   (optional) Default cinder volume_type for docker storage
#   Defaults to $::os_service_default
#
# [*default_etcd_volume_type*]
#   (optional) Default cinder volume_type for etcd storage
#   Defaults to $::os_service_default
#
# [*default_boot_volume_type*]
#   (optional) Default cinder volume_type for boot disk
#   Defaults to $::os_service_default
#
# [*default_boot_volume_size*]
#   (optional) Default volume size for boot disk
#   Defaults to $::os_service_default
#
class magnum::cinder (
  $default_docker_volume_type = $::os_service_default,
  $default_etcd_volume_type   = $::os_service_default,
  $default_boot_volume_type   = $::os_service_default,
  $default_boot_volume_size   = $::os_service_default,
) {

  include magnum::deps

  magnum_config {
    'cinder/default_docker_volume_type': value => $default_docker_volume_type;
    'cinder/default_etcd_volume_type': value   => $default_etcd_volume_type;
    'cinder/default_boot_volume_type': value   => $default_boot_volume_type;
    'cinder/default_boot_volume_size': value   => $default_boot_volume_size;
  }

}

