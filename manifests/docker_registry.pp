# == Class: magnum::docker_registry
#
# Setup magnum docker_registry.
#
# === Parameters
#
# [*swift_region*]
#   (optional) Region name of Swift.
#   Defaults to $facts['os_service_default']
#
# [*swift_registry_container*]
#   (optional) Name of the container in Swift which docker registry stores
#   images in.
#   Defaults to $facts['os_service_default']
#
class magnum::docker_registry (
  $swift_region             = $facts['os_service_default'],
  $swift_registry_container = $facts['os_service_default'],
) {
  include magnum::deps

  magnum_config {
    'docker_registry/swift_region':             value => $swift_region;
    'docker_registry/swift_registry_container': value => $swift_registry_container;
  }
}
