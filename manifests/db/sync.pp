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
#   Defaults to undef
#
# [*exec_path*]
#   (Optional) The path  to use for finding the magnum-db-manage binary.
#   Defaults to '/usr/bin'
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class magnum::db::sync(
  $user            = 'magnum',
  $extra_params    = '--config-file /etc/magnum/magnum.conf',
  $exec_path       = '/usr/bin',
  $db_sync_timeout = 300,
) {

  include magnum::deps

  exec { 'magnum-db-sync':
    command     => "magnum-db-manage ${extra_params} upgrade head",
    path        => $exec_path,
    user        => $user,
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
