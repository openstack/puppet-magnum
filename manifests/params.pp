# Parameters for puppet-magnum
#
class magnum::params {

  case $::osfamily {
    'RedHat': {
      # package names
      $common_package_name  = 'openstack-magnum-common'
      $api_package          = 'openstack-magnum-api'
      $api_service          = 'openstack-magnum-api'
      $sqlite_package_name  = undef
    }
    'Debian': {
      # package names
      $common_package_name  = 'magnum-common'
      $api_package          = 'magnum-api'
      $api_service          = 'magnum-api'
      $sqlite_package_name  = 'python-pysqlite2'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
