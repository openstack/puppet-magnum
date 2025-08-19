# == Class: magnum::certificates
#
# Manages the magnum certificate manager plugin
#
# === Parameters:
#
# [*cert_manager_type*]
#   (optional) Certificate Manager plugin.
#   Defaults to $facts['os_service_default']
#
# [*storage_path*]
#   (optional) Absolute path of the certificate storage directory.
#   Defaults to $facts['os_service_default']
#
class magnum::certificates (
  $cert_manager_type = $facts['os_service_default'],
  $storage_path      = $facts['os_service_default'],
) {
  include magnum::deps

  magnum_config {
    'certificates/cert_manager_type': value => $cert_manager_type;
    'certificates/storage_path':      value => $storage_path;
  }
}
