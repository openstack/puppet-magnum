# == Class: magnum::config
#
# This class is used to manage arbitrary magnum configurations.
#
# === Parameters
#
# [*magnum_config*]
#   (optional) Allow configuration of arbitrary magnum configurations.
#   The value is an hash of magnum_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   magnum_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class magnum::config (
  $magnum_config = {},
) {

  validate_hash($magnum_config)

  create_resources('magnum_config', $magnum_config)
}
