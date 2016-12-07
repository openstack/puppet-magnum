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

  include ::magnum::deps

  exec { 'magnum-db-sync':
    command     => "magnum-db-manage ${extra_params} upgrade head",
    path        => '/usr/bin',
    user        => $user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['magnum::install::end'],
      Anchor['magnum::config::end'],
      Anchor['magnum::dbsync::begin']
    ],
    notify      => Anchor['magnum::dbsync::end'],
  }

}
