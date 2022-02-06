# == Class: magnum::keystone::auth
#
# Configures magnum user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for magnum user.
#
# [*auth_name*]
#   (Optional) Username for magnum service.
#   Defaults to 'magnum'.
#
# [*email*]
#   (Optional) Email for magnum user.
#   Defaults to 'magnum@localhost'.
#
# [*tenant*]
#   (Optional) Tenant for magnum user.
#   Defaults to 'services'.
#
# [*roles*]
#   (Optional) List of roles assigned to magnum user.
#   Defaults to ['admin']
#
# [*system_scope*]
#   (Optional) Scope for system operations.
#   Defaults to 'all'
#
# [*system_roles*]
#   (Optional) List of system roles assigned to magnum user.
#   Defaults to []
#
# [*configure_endpoint*]
#   (Optional) Should magnum endpoint be configured?
#   Defaults to true.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true.
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to true.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'container-infra'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to the value of auth_name.
#
# [*service_description*]
#   (Optional) Description of the service.
#   Default to 'magnum Container Service'
#
# [*public_url*]
#   (0ptional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9511/v1'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9511/v1'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   Defaults to 'http://127.0.0.1:9511/v1'
#
class magnum::keystone::auth (
  $password,
  $auth_name           = 'magnum',
  $email               = 'magnum@localhost',
  $tenant              = 'services',
  $roles               = ['admin'],
  $system_scope        = 'all',
  $system_roles        = [],
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_description = 'magnum Container Service',
  $service_name        = undef,
  $service_type        = 'container-infra',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:9511/v1',
  $admin_url           = 'http://127.0.0.1:9511/v1',
  $internal_url        = 'http://127.0.0.1:9511/v1',
) {

  include magnum::deps

  $real_service_name = pick($service_name, $auth_name)

  Keystone::Resource::Service_identity['magnum'] -> Anchor['magnum::service::end']

  keystone::resource::service_identity { 'magnum':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $real_service_name,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }

}
