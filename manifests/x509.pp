# == Class: magnum::x509
#
# Manages the magnum x509 config
#
# === Parameters:
#
# [*allow_ca*]
#   (optional) Certificate can get the CA flag in x509 extensions.
#   Defaults to $::os_service_default
#
# [*allowed_extensions*]
#   (optional) List of allowed x509 extensions.
#   Defaults to $::os_service_default
#
# [*allowed_key_usage*]
#   (optional) List of allowed x509 key usage.
#   Defaults to $::os_service_default
#
# [*term_of_validity*]
#   (optional) Number of days for which a certificate is valid.
#   Defaults to $::os_service_default
#
# [*rsa_key_size*]
#   (optional) Size of generated private key.
#   Defaults to $::os_service_default
#
class magnum::x509 (
  $allow_ca           = $::os_service_default,
  $allowed_extensions = $::os_service_default,
  $allowed_key_usage  = $::os_service_default,
  $term_of_validity   = $::os_service_default,
  $rsa_key_size       = $::os_service_default,
) {

  include magnum::deps

  magnum_config {
    'x509/allow_ca':           value => $allow_ca;
    'x509/allowed_extensions': value => join(any2array($allowed_extensions), ',');
    'x509/allowed_key_usage':  value => join(any2array($allowed_key_usage), ',');
    'x509/term_of_validity':   value => $term_of_validity;
    'x509/rsa_key_size':       value => $rsa_key_size;
  }

}

