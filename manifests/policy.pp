# == Class: magnum::policy
#
# Configure the magnum policies
#
# === Parameters
#
# [*enforce_scope*]
#  (Optional) Whether or not to enforce scope when evaluating policies.
#  Defaults to $::os_service_default.
#
# [*enforce_new_defaults*]
#  (Optional) Whether or not to use old deprecated defaults when evaluating
#  policies.
#  Defaults to $::os_service_default.
#
# [*policies*]
#   (Optional) Set of policies to configure for magnum
#   Example :
#     {
#       'magnum-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'magnum-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the magnum policy.yaml file
#   Defaults to /etc/magnum/policy.yaml
#
# [*policy_dirs*]
#   (Optional) Path to the keystone policy folder
#   Defaults to $::os_service_default
#
class magnum::policy (
  $enforce_scope        = $::os_service_default,
  $enforce_new_defaults = $::os_service_default,
  $policies             = {},
  $policy_path          = '/etc/magnum/policy.yaml',
  $policy_dirs          = $::os_service_default,
) {

  include magnum::deps
  include magnum::params

  validate_legacy(Hash, 'validate_hash', $policies)

  Openstacklib::Policy::Base {
    file_path   => $policy_path,
    file_user   => 'root',
    file_group  => $::magnum::params::group,
    file_format => 'yaml',
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'magnum_config':
    enforce_scope        => $enforce_scope,
    enforce_new_defaults => $enforce_new_defaults,
    policy_file          => $policy_path,
    policy_dirs          => $policy_dirs,
  }

}
