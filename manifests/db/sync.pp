#
# Class to execute magnum-manage db_sync
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the magnum-dbsync command.
#   Defaults to undef
#
class magnum::db::sync(
  $extra_params  = undef,
) {
  exec { 'magnum-db-sync':
    command     => "magnum-manage db_sync ${extra_params}",
    path        => '/usr/bin',
    user        => 'magnum',
    refreshonly => true,
    subscribe   => [Package['magnum'], Magnum_config['database/connection']],
  }

  Exec['magnum-manage db_sync'] ~> Service<| title == 'magnum' |>
}
