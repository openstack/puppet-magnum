# == Class: magnum
#
# magnum base package & configuration
#
# === Parameters
#
# [*package_ensure*]
#  (Optional) Ensure state for package
#  Defaults to 'present'
#
# [*notification_transport_url*]
#  (Optional) A URL representing the messaging driver to use for notifications
#  and its full configuration. Transport URLs take the form:
#  transport://user:pass@host1:port[,hostN:portN]/virtual_host
#  Defaults to $::os_service_default
#
# [*notification_topics*]
#  (Optional) AMQP topics to publish to when using the RPC notification driver.
#  (list value)
#  Default to $::os_service_default
#
# [*notification_driver*]
#  (Optional) Notification driver to use
#  Defaults to $::os_service_default
#
# [*default_transport_url*]
#  (Optional) A URL representing the messaging driver to use and its full
#  configuration. Transport URLs take the form:
#  transport://user:pass@host1:port[,hostN:portN]/virtual_host
#  Defaults to $::os_service_default
#
# [*rpc_response_timeout*]
#  (Optional) Seconds to wait for a response from a call.
#  Defaults to $::os_service_default
#
# [*control_exchange*]
#  (Optional) The default exchange under which topics are scoped. May be
#  overridden by an exchange name specified in the transport_url
#  option.
#  Defaults to $::os_service_default
#
# [*rabbit_ha_queues*]
#   (Optional) Use HA queues in RabbitMQ.
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (optional) Number of seconds after which the RabbitMQ broker is considered
#   down if the heartbeat keepalive fails.  Any value >0 enables heartbeats.
#   Heartbeating helps to ensure the TCP connection to RabbitMQ isn't silently
#   closed, resulting in missed or lost messages from the queue.
#   (Requires kombu >= 3.0.7 and amqp >= 1.4.0)
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_rate*]
#   (optional) How often during the rabbit_heartbeat_timeout_threshold period to
#   check the heartbeat on RabbitMQ connection.  (i.e. rabbit_heartbeat_rate=2
#   when rabbit_heartbeat_timeout_threshold=60, the heartbeat will be checked
#   every 30 seconds.
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_in_pthread*]
#   (Optional) EXPERIMENTAL: Run the health check heartbeat thread
#   through a native python thread. By default if this
#   option isn't provided the  health check heartbeat will
#   inherit the execution model from the parent process. By
#   example if the parent process have monkey patched the
#   stdlib by using eventlet/greenlet then the heartbeat
#   will be run through a green thread.
#   Defaults to $::os_service_default
#
# [*rabbit_use_ssl*]
#  (Optional) Connect over SSL for rabbit
#  Defaults to $::os_service_default
#
# [*kombu_ssl_ca_certs*]
#  (Optional) SSL certification authority file (valid only if rabbit SSL is enabled)
#  Defaults to $::os_service_default
#
# [*kombu_ssl_certfile*]
#  (Optional) SSL cert file (valid only if rabbit SSL is enabled)
#  Defaults to $::os_service_default
#
# [*kombu_ssl_keyfile*]
#  (Optional) SSL key file (valid only if rabbit SSL is enabled)
#  Defaults to $::os_service_default
#
# [*kombu_ssl_version*]
#  (Optional) SSL version to use (valid only if rabbit SSL is enabled).
#  Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be available
#  on some distributions.
#  Defaults to $::os_service_default
#
# [*kombu_reconnect_delay*]
#   (Optional) How long to wait before reconnecting in response
#   to an AMQP consumer cancel notification. (floating point value)
#   Defaults to $::os_service_default
#
# [*kombu_failover_strategy*]
#  (Optional) Determines how the next RabbitMQ node is chosen in case the one
#  we are currently connected to becomes unavailable. Takes effect only if
#  more than one RabbitMQ node is provided in config. (string value)
#  Defaults to $::os_service_default
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may not be available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $::os_service_default
#
# [*amqp_durable_queues*]
#   (Optional) Use durable queues in amqp.
#   Defaults to $::os_service_default.
#
# [*amqp_server_request_prefix*]
#   (Optional) Address prefix used when sending to a specific server
#   Defaults to $::os_service_default.
#
# [*amqp_broadcast_prefix*]
#   (Optional) address prefix used when broadcasting to all servers
#   Defaults to $::os_service_default.
#
# [*amqp_group_request_prefix*]
#   (Optional) address prefix when sending to any server in group
#   Defaults to $::os_service_default.
#
# [*amqp_container_name*]
#   (Optional) Name for the AMQP container
#   Defaults to $::os_service_default.
#
# [*amqp_idle_timeout*]
#   (Optional) Timeout for inactive connections
#   Defaults to $::os_service_default.
#
# [*amqp_trace*]
#   (Optional) Debug: dump AMQP frames to stdout
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_ca_file*]
#   (Optional) CA certificate PEM file to verify server certificate
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_cert_file*]
#   (Optional) Identifying certificate PEM file to present to clients
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_key_file*]
#   (Optional) Private key PEM file used to sign cert_file certificate
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_key_password*]
#   (Optional) Password for decrypting ssl_key_file (if encrypted)
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_mechanisms*]
#   (Optional) Space separated list of acceptable SASL mechanisms
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_config_dir*]
#   (Optional) Path to directory that contains the SASL configuration
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_config_name*]
#   (Optional) Name of configuration file (without .conf suffix)
#   Defaults to $::os_service_default.
#
# [*amqp_username*]
#   (Optional) User name for message broker authentication
#   Defaults to $::os_service_default.
#
# [*amqp_password*]
#   (Optional) Password for message broker authentication
#   Defaults to $::os_service_default.
#
# [*purge_config*]
#  (Optional) Whether to set only the specified config options
#  in the magnum config.
#  Defaults to false.
#
class magnum(
  $package_ensure                     = 'present',
  $notification_transport_url         = $::os_service_default,
  $notification_driver                = $::os_service_default,
  $notification_topics                = $::os_service_default,
  $default_transport_url              = $::os_service_default,
  $rpc_response_timeout               = $::os_service_default,
  $control_exchange                   = $::os_service_default,
  $rabbit_ha_queues                   = $::os_service_default,
  $rabbit_heartbeat_timeout_threshold = $::os_service_default,
  $rabbit_heartbeat_rate              = $::os_service_default,
  $rabbit_heartbeat_in_pthread        = $::os_service_default,
  $rabbit_use_ssl                     = $::os_service_default,
  $kombu_ssl_ca_certs                 = $::os_service_default,
  $kombu_ssl_certfile                 = $::os_service_default,
  $kombu_ssl_keyfile                  = $::os_service_default,
  $kombu_ssl_version                  = $::os_service_default,
  $kombu_reconnect_delay              = $::os_service_default,
  $kombu_failover_strategy            = $::os_service_default,
  $kombu_compression                  = $::os_service_default,
  $amqp_durable_queues                = $::os_service_default,
  $amqp_server_request_prefix         = $::os_service_default,
  $amqp_broadcast_prefix              = $::os_service_default,
  $amqp_group_request_prefix          = $::os_service_default,
  $amqp_container_name                = $::os_service_default,
  $amqp_idle_timeout                  = $::os_service_default,
  $amqp_trace                         = $::os_service_default,
  $amqp_ssl_ca_file                   = $::os_service_default,
  $amqp_ssl_cert_file                 = $::os_service_default,
  $amqp_ssl_key_file                  = $::os_service_default,
  $amqp_ssl_key_password              = $::os_service_default,
  $amqp_sasl_mechanisms               = $::os_service_default,
  $amqp_sasl_config_dir               = $::os_service_default,
  $amqp_sasl_config_name              = $::os_service_default,
  $amqp_username                      = $::os_service_default,
  $amqp_password                      = $::os_service_default,
  $purge_config                       = false,
) {

  include magnum::deps
  include magnum::params
  include magnum::policy
  include magnum::db

  package { 'magnum-common':
    ensure => $package_ensure,
    name   => $::magnum::params::common_package,
    tag    => ['openstack', 'magnum-package'],
  }

  resources { 'magnum_config':
    purge => $purge_config,
  }

  oslo::messaging::rabbit { 'magnum_config':
    rabbit_ha_queues            => $rabbit_ha_queues,
    heartbeat_timeout_threshold => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate              => $rabbit_heartbeat_rate,
    heartbeat_in_pthread        => $rabbit_heartbeat_in_pthread,
    rabbit_use_ssl              => $rabbit_use_ssl,
    kombu_reconnect_delay       => $kombu_reconnect_delay,
    kombu_failover_strategy     => $kombu_failover_strategy,
    kombu_ssl_version           => $kombu_ssl_version,
    kombu_ssl_keyfile           => $kombu_ssl_keyfile,
    kombu_ssl_certfile          => $kombu_ssl_certfile,
    kombu_ssl_ca_certs          => $kombu_ssl_ca_certs,
    amqp_durable_queues         => $amqp_durable_queues,
    kombu_compression           => $kombu_compression,
  }

  oslo::messaging::amqp { 'magnum_config':
    server_request_prefix => $amqp_server_request_prefix,
    broadcast_prefix      => $amqp_broadcast_prefix,
    group_request_prefix  => $amqp_group_request_prefix,
    container_name        => $amqp_container_name,
    idle_timeout          => $amqp_idle_timeout,
    trace                 => $amqp_trace,
    ssl_ca_file           => $amqp_ssl_ca_file,
    ssl_cert_file         => $amqp_ssl_cert_file,
    ssl_key_file          => $amqp_ssl_key_file,
    ssl_key_password      => $amqp_ssl_key_password,
    sasl_mechanisms       => $amqp_sasl_mechanisms,
    sasl_config_dir       => $amqp_sasl_config_dir,
    sasl_config_name      => $amqp_sasl_config_name,
    username              => $amqp_username,
    password              => $amqp_password,
  }

  oslo::messaging::default { 'magnum_config':
    transport_url        => $default_transport_url,
    rpc_response_timeout => $rpc_response_timeout,
    control_exchange     => $control_exchange,
  }

  oslo::messaging::notifications { 'magnum_config':
    transport_url => $notification_transport_url,
    driver        => $notification_driver,
    topics        => $notification_topics,
  }

}
