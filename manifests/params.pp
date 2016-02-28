# Parameters for puppet-magnum
#
class magnum::params {

  case $::osfamily {
    'RedHat': {
      # package names
      $common_package         = 'openstack-magnum-common'
      $api_package            = 'openstack-magnum-api'
      $conductor_package      = 'openstack-magnum-conductor'
      $sqlite_package         = undef
      # service names
      $api_service            = 'openstack-magnum-api'
      $conductor_service      = 'openstack-magnum-conductor'
    }
    'Debian': {
      # package names
      $common_package         = 'magnum-common'
      $api_package            = 'magnum-api'
      $conductor_package      = 'magnum-conductor'
      $sqlite_package         = 'python-pysqlite2'
      # service names
      $api_service            = 'magnum-api'
      $conductor_service      = 'magnum-conductor'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
