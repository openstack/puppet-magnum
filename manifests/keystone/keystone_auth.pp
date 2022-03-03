# class: magnum::keystone::keystone_auth
#
# Configure the keystone_auth section in the configuration file
#
# === Parameters
#
# [*username*]
#   (Optional) The name of the service user
#   Defaults to 'magnum'
#
# [*password*]
#   (Required) Password to create for the service user
#   Defaults to $::os_service_default
#
# [*auth_url*]
#   (Optional) The URL to use for authentication.
#   Defaults to 'http://localhost:5000'
#
# [*project_name*]
#   (Optional) Service project name
#   Defaults to 'services'
#
# [*user_domain_name*]
#   (Optional) Name of domain for $username
#   Defaults to 'Default'
#
# [*project_domain_name*]
#   (Optional) Name of domain for $project_name
#   Defaults to 'Default'
#
# [*system_scope*]
#  (Optional) Scope for system operations.
#  Defauls to $::os_service_default
#
# [*auth_type*]
#   (Optional) Authentication type to load
#   Defaults to 'password'
#
class magnum::keystone::keystone_auth(
  $username            = 'magnum',
  $password            = $::os_service_default,
  $auth_url            = 'http://localhost:5000',
  $project_name        = 'services',
  $user_domain_name    = 'Default',
  $project_domain_name = 'Default',
  $system_scope        = $::os_service_default,
  $auth_type           = 'password',
) {

  include magnum::deps

  if is_service_default($system_scope) {
    $project_name_real = $project_name
    $project_domain_name_real = $project_domain_name
  } else {
    $project_name_real = $::os_service_default
    $project_domain_name_real = $::os_service_default
  }

  # Only configure keystone_auth if user specifics a password; this keeps
  # backwards compatibility
  if !is_service_default($password) {
    magnum_config {
      'keystone_auth/auth_url'            : value => $auth_url;
      'keystone_auth/username'            : value => $username;
      'keystone_auth/password'            : value => $password, secret => true;
      'keystone_auth/project_name'        : value => $project_name_real;
      'keystone_auth/user_domain_name'    : value => $user_domain_name;
      'keystone_auth/project_domain_name' : value => $project_domain_name_real;
      'keystone_auth/system_scope'        : value => $system_scope;
      'keystone_auth/auth_type'           : value => $auth_type;
    }
  }
}
