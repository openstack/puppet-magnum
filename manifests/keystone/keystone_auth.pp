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
class magnum::keystone::keystone_auth(
  $username            = 'magnum',
  $password            = $::os_service_default,
  $auth_url            = 'http://localhost:5000',
  $project_name        = 'services',
  $user_domain_name    = 'Default',
  $project_domain_name = 'Default',
) {

  include magnum::deps

  # Only configure keystone_auth if user specifics a password; this keeps
  # backwards compatibility
  if !is_service_default($password) {
    magnum_config {
      'keystone_auth/auth_url'            : value => $auth_url;
      'keystone_auth/username'            : value => $username;
      'keystone_auth/password'            : value => $password, secret => true;
      'keystone_auth/project_name'        : value => $project_name;
      'keystone_auth/project_domain_name' : value => $project_domain_name;
      'keystone_auth/user_domain_name'    : value => $user_domain_name;
    }
  }
}
