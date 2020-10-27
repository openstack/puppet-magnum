# == Class: magnum::quota
#
# Setup magnum quota.
#
# === Parameters
#
# [*max_clusters_per_project*]
#   (optional) Number of clusters allowed per project.
#   Defaults to $::os_service_default.
#
class magnum::quota (
  $max_clusters_per_project = $::os_service_default
) {

  magnum_config {
    'quotas/max_clusters_per_project': value => $max_clusters_per_project;
  }
}
