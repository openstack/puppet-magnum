# ==Class: magnum::params
#
# Parameters for puppet-magnum
#
class magnum::params {
  include openstacklib::defaults

  $user  = 'magnum'
  $group = 'magnum'

  case $::osfamily {
    'RedHat': {
      # package names
      $common_package     = 'openstack-magnum-common'
      $api_package        = 'openstack-magnum-api'
      $conductor_package  = 'openstack-magnum-conductor'
      # service names
      $api_service        = 'openstack-magnum-api'
      $conductor_service  = 'openstack-magnum-conductor'
      $client_package     = 'python3-magnumclient'
      $wsgi_script_path   = '/var/www/cgi-bin/magnum'
      $wsgi_script_source = '/usr/bin/magnum-api-wsgi'
    }
    'Debian': {
      # package names
      $common_package     = 'magnum-common'
      $api_package        = 'magnum-api'
      $conductor_package  = 'magnum-conductor'
      # service names
      $api_service        = 'magnum-api'
      $conductor_service  = 'magnum-conductor'
      $client_package     = 'python3-magnumclient'
      $wsgi_script_path   = '/usr/lib/cgi-bin/magnum'
      $wsgi_script_source = '/usr/bin/magnum-api-wsgi'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
