# == Class: magnum::cluster
#
# Setup magnum cluster.
#
# === Parameters
#
# [*etcd_discovery_service_endpoint_format*]
#   (optional) Url for etcd public discovery endpoint.
#   Defaults to $facts['os_service_default']
#
# [*nodes_affinity_policy*]
#   (optional) Affinity policy for server group of cluster nodes.
#   Defaults to $facts['os_service_default']
#
# [*temp_cache_dir*]
#   (optional) Explicitly specify the temporary directory to hold cached TLS
#   certs.
#   Defaults to $facts['os_service_default']
#
# [*pre_delete_lb_timeout*]
#   (optional) The timeout in seconds to wait for the load balancers to be
#   deleted.
#   Defaults to $facts['os_service_default']
#
class magnum::cluster (
  $etcd_discovery_service_endpoint_format = $facts['os_service_default'],
  $nodes_affinity_policy                  = $facts['os_service_default'],
  $temp_cache_dir                         = $facts['os_service_default'],
  $pre_delete_lb_timeout                  = $facts['os_service_default'],
) {

  include magnum::deps

  magnum_config {
    'cluster/etcd_discovery_service_endpoint_format': value => $etcd_discovery_service_endpoint_format;
    'cluster/nodes_affinity_policy':                  value => $nodes_affinity_policy;
    'cluster/temp_cache_dir':                         value => $temp_cache_dir;
    'cluster/pre_delete_lb_timeout':                  value => $pre_delete_lb_timeout;
  }
}
