#
# Class to execute magnum-manage db_sync
#
# == Parameters
#
# [*user*]
#   (Optional) User to run dbsync command.
#   Defaults to 'magnum'
#
# [*extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the magnum-dbsync command.
#   Defaults to ''
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class magnum::db::sync(
  $user            = 'magnum',
  $extra_params    = '',
  $db_sync_timeout = 300,
) {

  include magnum::deps
  include magnum::params

  exec { 'magnum-db-sync':
    command     => "magnum-db-manage ${extra_params} upgrade head",
    path        => ['/bin', '/usr/bin'],
    user        => $::magnum::params::user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['magnum::install::end'],
      Anchor['magnum::config::end'],
      Anchor['magnum::dbsync::begin']
    ],
    notify      => Anchor['magnum::dbsync::end'],
    tag         => 'openstack-db',
  }

}
