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
# [*host*]
#   (optional) Name of this node.
#   Defaults to $facts['os_service_default'].
#
# [*notification_transport_url*]
#   (Optional) A URL representing the messaging driver to use for notifications
#   and its full configuration. Transport URLs take the form:
#   transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $facts['os_service_default']
#
# [*notification_topics*]
#   (Optional) AMQP topics to publish to when using the RPC notification driver.
#   (list value)
#   Default to $facts['os_service_default']
#
# [*notification_driver*]
#   (Optional) Notification driver to use
#   Defaults to $facts['os_service_default']
#
# [*notification_retry*]
#   (Optional) The maximum number of attempts to re-sent a notification
#   message, which failed to be delivered due to a recoverable error.
#   Defaults to $facts['os_service_default'].
#
# [*default_transport_url*]
#   (Optional) A URL representing the messaging driver to use and its full
#   configuration. Transport URLs take the form:
#   transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $facts['os_service_default']
#
# [*rpc_response_timeout*]
#   (Optional) Seconds to wait for a response from a call.
#   Defaults to $facts['os_service_default']
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped. May be
#   overridden by an exchange name specified in the transport_url
#   option.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_ha_queues*]
#   (Optional) Use HA queues in RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (optional) Number of seconds after which the RabbitMQ broker is considered
#   down if the heartbeat keepalive fails.  Any value >0 enables heartbeats.
#   Heartbeating helps to ensure the TCP connection to RabbitMQ isn't silently
#   closed, resulting in missed or lost messages from the queue.
#   (Requires kombu >= 3.0.7 and amqp >= 1.4.0)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_rate*]
#   (optional) How often during the rabbit_heartbeat_timeout_threshold period to
#   check the heartbeat on RabbitMQ connection.  (i.e. rabbit_heartbeat_rate=2
#   when rabbit_heartbeat_timeout_threshold=60, the heartbeat will be checked
#   every 30 seconds.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_qos_prefetch_count*]
#   (Optional) Specifies the number of messages to prefetch.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_queue*]
#   (Optional) Use quorum queues in RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_transient_quorum_queue*]
#   (Optional) Use quorum queues for transients queues in RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_transient_queues_ttl*]
#   (Optional) Positive integer representing duration in seconds for
#   queue TTL (x-expires). Queues which are unused for the duration
#   of the TTL are automatically deleted.
#   The parameter affects only reply and fanout queues. (integer value)
#   Min to 1
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_delivery_limit*]
#   (Optional) Each time a message is rdelivered to a consumer, a counter is
#   incremented. Once the redelivery count exceeds the delivery limit
#   the message gets dropped or dead-lettered.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_max_memory_length*]
#   (Optional) Limit the number of messages in the quorum queue.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_max_memory_bytes*]
#   (Optional) Limit the number of memory bytes used by the quorum queue.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_use_queue_manager*]
#   (Optional) Should we use consistant queue names or random ones.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_stream_fanout*]
#   (Optional) Use stream queues in RabbitMQ (x-queue-type: stream).
#   Defaults to $facts['os_service_default']
#
# [*rabbit_enable_cancel_on_failover*]
#   (Optional) Enable x-cancel-on-ha-failover flag so that rabbitmq server will
#   cancel and notify consumers when queue is down.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_use_ssl*]
#  (Optional) Connect over SSL for rabbit
#  Defaults to $facts['os_service_default']
#
# [*kombu_ssl_ca_certs*]
#  (Optional) SSL certification authority file (valid only if rabbit SSL is enabled)
#  Defaults to $facts['os_service_default']
#
# [*kombu_ssl_certfile*]
#  (Optional) SSL cert file (valid only if rabbit SSL is enabled)
#  Defaults to $facts['os_service_default']
#
# [*kombu_ssl_keyfile*]
#  (Optional) SSL key file (valid only if rabbit SSL is enabled)
#  Defaults to $facts['os_service_default']
#
# [*kombu_ssl_version*]
#  (Optional) SSL version to use (valid only if rabbit SSL is enabled).
#  Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be available
#  on some distributions.
#  Defaults to $facts['os_service_default']
#
# [*kombu_reconnect_delay*]
#   (Optional) How long to wait before reconnecting in response
#   to an AMQP consumer cancel notification. (floating point value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_failover_strategy*]
#  (Optional) Determines how the next RabbitMQ node is chosen in case the one
#  we are currently connected to becomes unavailable. Takes effect only if
#  more than one RabbitMQ node is provided in config. (string value)
#  Defaults to $facts['os_service_default']
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may not be available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $facts['os_service_default']
#
# [*amqp_durable_queues*]
#   (Optional) Use durable queues in amqp.
#   Defaults to $facts['os_service_default'].
#
# [*amqp_auto_delete*]
#   (Optional) Define if transient queues should be auto-deleted (boolean value)
#   Defaults to $facts['os_service_default']
#
# [*purge_config*]
#  (Optional) Whether to set only the specified config options
#  in the magnum config.
#  Defaults to false.
#
# DEPRECATED PARAMETERS
#
# [*rabbit_heartbeat_in_pthread*]
#   (Optional) EXPERIMENTAL: Run the health check heartbeat thread
#   through a native python thread. By default if this
#   option isn't provided the  health check heartbeat will
#   inherit the execution model from the parent process. By
#   example if the parent process have monkey patched the
#   stdlib by using eventlet/greenlet then the heartbeat
#   will be run through a green thread.
#   Defaults to undef
#
class magnum (
  $package_ensure                     = 'present',
  $host                               = $facts['os_service_default'],
  $notification_transport_url         = $facts['os_service_default'],
  $notification_driver                = $facts['os_service_default'],
  $notification_topics                = $facts['os_service_default'],
  $notification_retry                 = $facts['os_service_default'],
  $default_transport_url              = $facts['os_service_default'],
  $rpc_response_timeout               = $facts['os_service_default'],
  $control_exchange                   = $facts['os_service_default'],
  $rabbit_ha_queues                   = $facts['os_service_default'],
  $rabbit_heartbeat_timeout_threshold = $facts['os_service_default'],
  $rabbit_heartbeat_rate              = $facts['os_service_default'],
  $rabbit_qos_prefetch_count          = $facts['os_service_default'],
  $rabbit_quorum_queue                = $facts['os_service_default'],
  $rabbit_transient_queues_ttl        = $facts['os_service_default'],
  $rabbit_transient_quorum_queue      = $facts['os_service_default'],
  $rabbit_quorum_delivery_limit       = $facts['os_service_default'],
  $rabbit_quorum_max_memory_length    = $facts['os_service_default'],
  $rabbit_quorum_max_memory_bytes     = $facts['os_service_default'],
  $rabbit_use_queue_manager           = $facts['os_service_default'],
  $rabbit_stream_fanout               = $facts['os_service_default'],
  $rabbit_enable_cancel_on_failover   = $facts['os_service_default'],
  $rabbit_use_ssl                     = $facts['os_service_default'],
  $kombu_ssl_ca_certs                 = $facts['os_service_default'],
  $kombu_ssl_certfile                 = $facts['os_service_default'],
  $kombu_ssl_keyfile                  = $facts['os_service_default'],
  $kombu_ssl_version                  = $facts['os_service_default'],
  $kombu_reconnect_delay              = $facts['os_service_default'],
  $kombu_failover_strategy            = $facts['os_service_default'],
  $kombu_compression                  = $facts['os_service_default'],
  $amqp_durable_queues                = $facts['os_service_default'],
  $amqp_auto_delete                   = $facts['os_service_default'],
  Boolean $purge_config               = false,
  # DEPRECATED PARAMETERS
  $rabbit_heartbeat_in_pthread        = undef,
) {
  include magnum::deps
  include magnum::params
  include magnum::policy
  include magnum::db

  package { 'magnum-common':
    ensure => $package_ensure,
    name   => $magnum::params::common_package,
    tag    => ['openstack', 'magnum-package'],
  }

  resources { 'magnum_config':
    purge => $purge_config,
  }

  magnum_config {
    'DEFAULT/host': value => $host;
  }

  oslo::messaging::rabbit { 'magnum_config':
    rabbit_ha_queues                => $rabbit_ha_queues,
    heartbeat_timeout_threshold     => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate                  => $rabbit_heartbeat_rate,
    heartbeat_in_pthread            => $rabbit_heartbeat_in_pthread,
    rabbit_qos_prefetch_count       => $rabbit_qos_prefetch_count,
    rabbit_use_ssl                  => $rabbit_use_ssl,
    kombu_reconnect_delay           => $kombu_reconnect_delay,
    kombu_failover_strategy         => $kombu_failover_strategy,
    kombu_ssl_version               => $kombu_ssl_version,
    kombu_ssl_keyfile               => $kombu_ssl_keyfile,
    kombu_ssl_certfile              => $kombu_ssl_certfile,
    kombu_ssl_ca_certs              => $kombu_ssl_ca_certs,
    amqp_durable_queues             => $amqp_durable_queues,
    amqp_auto_delete                => $amqp_auto_delete,
    kombu_compression               => $kombu_compression,
    rabbit_quorum_queue             => $rabbit_quorum_queue,
    rabbit_transient_quorum_queue   => $rabbit_transient_quorum_queue,
    rabbit_transient_queues_ttl     => $rabbit_transient_queues_ttl,
    rabbit_quorum_delivery_limit    => $rabbit_quorum_delivery_limit,
    rabbit_quorum_max_memory_length => $rabbit_quorum_max_memory_length,
    rabbit_quorum_max_memory_bytes  => $rabbit_quorum_max_memory_bytes,
    use_queue_manager               => $rabbit_use_queue_manager,
    rabbit_stream_fanout            => $rabbit_stream_fanout,
    enable_cancel_on_failover       => $rabbit_enable_cancel_on_failover,
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
    retry         => $notification_retry,
  }
}
