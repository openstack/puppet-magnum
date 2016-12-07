# == Class: magnum::clients
#
# Manages the clients configuration in magnum server
#
# === Parameters:
#
# [*region_name*]
#   (optional) Region in Identity service catalog to use for communication
#   with the OpenStack service.
#   Defaults to RegionOne
#
# [*endpoint_type*]
#   (optional) Type of endpoint in Identity service catalog to use for
#   communication with the the OpenStack service.
#   Defaults to publicURL
#
class magnum::clients (
  $region_name   = 'RegionOne',
  $endpoint_type = 'publicURL',
) {

  include ::magnum::deps
  include ::magnum::params

  magnum_config {
    'cinder_client/region_name':   value => $region_name;
    'barbican_client/region_name': value => $region_name;
    'glance_client/region_name':   value => $region_name;
    'heat_client/region_name':     value => $region_name;
    'magnum_client/region_name':   value => $region_name;
    'neutron_client/region_name':  value => $region_name;
    'nova_client/region_name':     value => $region_name;
  }

  magnum_config {
    'barbican_client/endpoint_type': value => $endpoint_type;
    'glance_client/endpoint_type':   value => $endpoint_type;
    'heat_client/endpoint_type':     value => $endpoint_type;
    'magnum_client/endpoint_type':   value => $endpoint_type;
    'neutron_client/endpoint_type':  value => $endpoint_type;
    'nova_client/endpoint_type':     value => $endpoint_type;
  }


}
