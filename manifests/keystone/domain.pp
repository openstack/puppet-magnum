# == Class: magnum::keystone::domain
#
# Configures magnum domain in Keystone.
#
# === Parameters
#
# [*cluster_user_trust*]
#   enable creation of a user trust for clusters.
#   Defaults to $facts['os_service_default'].
#
# [*domain_name*]
#   magnum domain name.
#   Defaults to 'magnum'.
#
# [*domain_id*]
#   id of the domain to create trustee for clusters.
#   Defaults to $facts['os_service_default'].
#
# [*domain_admin*]
#   Keystone domain admin user which will be created.
#   Defaults to 'magnum_admin'.
#
# [*domain_admin_domain_name*]
#   Name of the domain admin user's domain.
#   Defaults to $domain_name.
#
# [*domain_admin_email*]
#   Keystone domain admin user email address.
#   Defaults to 'magnum_admin@localhost'.
#
# [*domain_password*]
#   Keystone domain admin user password.
#   Required when manage_user is true.
#   Defaults to 'changeme'.
#
# [*roles*]
#   The roles which are delegated to the trustee by the trustor.
#   Defaults to $facts['os_service_default'].
#
# [*keystone_interface*]
#   Auth interface used by instances/trustee.
#   Defaults to 'public'.
#
# [*keystone_region_name*]
#   Region in Identity service catalog to use for
#   communication with the OpenStack service.
#   Defaults to $facts['os_service_default'].
#
# [*manage_domain*]
#   Whether manage or not the domain creation.
#   If using the default domain, it needs to be False because puppet-keystone
#   can already manage it.
#   Defaults to 'true'.
#
# [*manage_user*]
#   Whether manage or not the user creation.
#   Defaults to 'true'.
#
# [*manage_role*]
#   Whether manage or not the user role creation.
#   Defaults to 'true'.
#
# DEPRECATED PARAMETERS
#
# [*domain_admin_id*]
#   Id of the admin with roles sufficient to manage users in the trustee_domain.
#   Defaults to $facts['os_service_default'].
#
# [*domain_admin_domain_id*]
#   Id of the domain admin user's domain.
#   Defaults to $facts['os_service_default'].
#
class magnum::keystone::domain (
  $cluster_user_trust       = $facts['os_service_default'],
  $domain_name              = 'magnum',
  $domain_id                = $facts['os_service_default'],
  $domain_admin             = 'magnum_admin',
  $domain_admin_email       = 'magnum_admin@localhost',
  $domain_password          = undef,
  $domain_admin_domain_name = $facts['os_service_default'],
  $roles                    = $facts['os_service_default'],
  $keystone_interface       = 'public',
  $keystone_region_name     = $facts['os_service_default'],
  Boolean $manage_domain    = true,
  Boolean $manage_user      = true,
  Boolean $manage_role      = true,
  # DEPRECATED PARAMETERS
  $domain_admin_id          = undef,
  $domain_admin_domain_id   = undef,
) {

  include magnum::deps
  include magnum::params

  if $domain_admin_id != undef {
    warning('The domain_admin_id parameter is deprecated')
  }
  if $domain_admin_domain_id != undef {
    warning('The domain_admin_domain_id parameter is deprecated')
  }

  if $manage_domain {
    ensure_resource('keystone_domain', $domain_name, {
      'ensure'  => 'present',
      'enabled' => true,
    })
  }

  if $manage_user {
    if $domain_password == undef {
      fail('domain_password is required when managing the domain user')
    }

    ensure_resource('keystone_user', "${domain_admin}::${domain_name}", {
      'ensure'   => 'present',
      'enabled'  => true,
      'email'    => $domain_admin_email,
      'password' => $domain_password,
    })
  }

  if $manage_role {
    ensure_resource('keystone_user_role', "${domain_admin}::${domain_name}@::${domain_name}", {
      'roles' => ['admin'],
    })
  }

  $domain_admin_id_real = pick($domain_admin_id, $facts['os_service_default'])
  $domain_admin_domain_id_real = pick($domain_admin_domain_id, $facts['os_service_default'])
  $domain_password_real = pick($domain_password, $facts['os_service_default'])

  magnum_config {
    'trust/cluster_user_trust':                value => $cluster_user_trust;
    'trust/trustee_domain_name':               value => $domain_name;
    'trust/trustee_domain_id':                 value => $domain_id;
    'trust/trustee_domain_admin_name':         value => $domain_admin;
    'trust/trustee_domain_admin_id':           value => $domain_admin_id_real;
    'trust/trustee_domain_admin_domain_name':  value => $domain_admin_domain_name;
    'trust/trustee_domain_admin_domain_id':    value => $domain_admin_domain_id_real;
    'trust/trustee_domain_admin_password':     value => $domain_password_real, secret => true;
    'trust/roles':                             value => join(any2array($roles), ',');
    'trust/trustee_keystone_interface':        value => $keystone_interface;
    'trust/trustee_keystone_region_name':      value => $keystone_region_name;
  }

}
