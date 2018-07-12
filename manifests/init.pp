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
#   (optional) A URL representing the messaging driver to use for notifications
#   and its full configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $::os_service_default
#
# [*notification_topics*]
#   (optional) AMQP topics to publish to when using the RPC notification driver.
#   (list value)
#   Default to $::os_service_default
#
# [*notification_driver*]
#  (Optional) Notification driver to use
#  Defaults to $::os_service_default
#
# [*default_transport_url*]
#  (optional) A URL representing the messaging driver to use and its full
#  configuration. Transport URLs take the form:
#    transport://user:pass@host1:port[,hostN:portN]/virtual_host
#  Defaults to $::os_service_default
#
# [*rpc_response_timeout*]
#  (Optional) Seconds to wait for a response from a call.
#  Defaults to $::os_service_default
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped. May be
#   overridden by an exchange name specified in the transport_url
#   option.
#   Defaults to $::os_service_default
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
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $::os_service_default
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the magnum config.
#   Defaults to false.
#
# [*amqp_durable_queues*]
#   (optional) Whether to use durable queues in AMQP.
#   Defaults to $::os_service_default.
#
# === DEPRECATED PARAMTERS
#
# [*rabbit_host*]
#  (Optional) Host for rabbit server
#  Defaults to $::os_service_default
#
# [*rabbit_hosts*]
#  (Optional) List of clustered rabbit servers
#  Defaults to $::os_service_default
#
# [*rabbit_port*]
#  (Optional) Port for rabbit server
#  Defaults to $::os_service_default
#
# [*rabbit_userid*]
#  (Optional) Username used to connecting to rabbit
#  Defaults to $::os_service_default
#
# [*rabbit_virtual_host*]
#  (Optional) Virtual host for rabbit server
#  Defaults to $::os_service_default
#
# [*rabbit_password*]
#  (Optional) Password used to connect to rabbit
#  Defaults to $::os_service_default
#
# [*rpc_backend*]
#  (optional) The rpc backend implementation to use, can be:
#  rabbit (for rabbitmq)
#  Defaults to 'rabbit'
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
  $rabbit_use_ssl                     = $::os_service_default,
  $kombu_ssl_ca_certs                 = $::os_service_default,
  $kombu_ssl_certfile                 = $::os_service_default,
  $kombu_ssl_keyfile                  = $::os_service_default,
  $kombu_ssl_version                  = $::os_service_default,
  $kombu_failover_strategy            = $::os_service_default,
  $purge_config                       = false,
  $amqp_durable_queues                = $::os_service_default,
  # DEPRECATED PARAMTERS
  $rabbit_host                        = $::os_service_default,
  $rabbit_hosts                       = $::os_service_default,
  $rabbit_port                        = $::os_service_default,
  $rabbit_userid                      = $::os_service_default,
  $rabbit_virtual_host                = $::os_service_default,
  $rabbit_password                    = $::os_service_default,
  $rpc_backend                        = 'rabbit',
) {

  include ::magnum::deps
  include ::magnum::params
  include ::magnum::logging
  include ::magnum::policy
  include ::magnum::db

  package { 'magnum-common':
    ensure => $package_ensure,
    name   => $::magnum::params::common_package,
    tag    => ['openstack', 'magnum-package'],
  }

  resources { 'magnum_config':
    purge => $purge_config,
  }

  if !is_service_default($rabbit_host) or
    !is_service_default($rabbit_hosts) or
    !is_service_default($rabbit_password) or
    !is_service_default($rabbit_port) or
    !is_service_default($rabbit_userid) or
    !is_service_default($rabbit_virtual_host) or
    $rpc_backend {
    warning("magnum::rabbit_host, magnum::rabbit_hosts, magnum::rabbit_password, \
magnum::rabbit_port, magnum::rabbit_userid, magnum::rabbit_virtual_host and \
magnum::rpc_backend are deprecated. Please use magnum::default_transport_url \
instead.")
  }

  oslo::messaging::rabbit { 'magnum_config':
    heartbeat_timeout_threshold => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate              => $rabbit_heartbeat_rate,
    rabbit_userid               => $rabbit_userid,
    rabbit_password             => $rabbit_password,
    rabbit_virtual_host         => $rabbit_virtual_host,
    rabbit_host                 => $rabbit_host,
    rabbit_port                 => $rabbit_port,
    rabbit_hosts                => $rabbit_hosts,
    rabbit_use_ssl              => $rabbit_use_ssl,
    kombu_ssl_version           => $kombu_ssl_version,
    kombu_ssl_keyfile           => $kombu_ssl_keyfile,
    kombu_ssl_certfile          => $kombu_ssl_certfile,
    kombu_ssl_ca_certs          => $kombu_ssl_ca_certs,
    kombu_failover_strategy     => $kombu_failover_strategy,
    rabbit_ha_queues            => $rabbit_ha_queues,
    amqp_durable_queues         => $amqp_durable_queues,
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
