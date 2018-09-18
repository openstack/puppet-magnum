# ==Class: magnum::params
#
# Parameters for puppet-magnum
#
class magnum::params {
  include ::openstacklib::defaults

  if ($::os_package_type == 'debian') {
    $pyvers = '3'
    $pyver3 = '3'
  } else {
    $pyvers = ''
    $pyver3 = '2.7'
  }

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
      $client_package     = 'python2-magnumclient'
      $wsgi_script_path   = '/var/www/cgi-bin/magnum'
      $wsgi_script_source = '/usr/lib/python2.7/site-packages/magnum/api/app.wsgi'
    }
    'Debian': {
      # package names
      $common_package     = 'magnum-common'
      $api_package        = 'magnum-api'
      $conductor_package  = 'magnum-conductor'
      # service names
      $api_service        = 'magnum-api'
      $conductor_service  = 'magnum-conductor'
      $client_package     = "python${pyvers}-magnumclient"
      $wsgi_script_path   = '/usr/lib/cgi-bin/magnum'
      $wsgi_script_source = "/usr/lib/python${pyver3}/dist-packages/magnum/api/app.wsgi"
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
