#
# Class to execute magnum-manage db_sync
#
# == Parameters
#
# [*user*]
#   (optional) User to run dbsync command.
#   Defaults to 'magnum'
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the magnum-dbsync command.
#   Defaults to undef
#
class magnum::db::sync(
  $user         = 'magnum',
  $extra_params = '--config-file /etc/magnum/magnum.conf',
) {
  exec { 'magnum-db-sync':
    command     => "magnum-db-manage ${extra_params} upgrade head",
    path        => '/usr/bin',
    user        => $user,
    refreshonly => true,
    logoutput   => on_failure,
  }

  Package<| tag == 'magnum-package' |> ~> Exec['magnum-db-sync']
  Exec['magnum-db-sync'] ~> Service<| tag == 'magnum-db-sync-service' |>
  Magnum_config<| title == 'database/connection' |> ~> Exec['magnum-db-sync']
  Magnum_config <| |> ~> Exec['magnum-db-sync']
}
