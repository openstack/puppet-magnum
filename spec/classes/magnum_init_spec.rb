require 'spec_helper'

describe 'magnum' do

  shared_examples 'magnum' do

    context 'with default parameters' do
      let :params do
        { :purge_config => false  }
      end

      it 'contains other classes' do
        is_expected.to contain_class('magnum::deps')
        is_expected.to contain_class('magnum::params')
        is_expected.to contain_class('magnum::db')
      end

      it 'installs packages' do
        is_expected.to contain_package('magnum-common').with(
          :ensure => 'present',
          :name   => platform_params[:magnum_common_package],
          :tag    => ['openstack', 'magnum-package']
        )
      end

      it 'passes purge to resource' do
        is_expected.to contain_resources('magnum_config').with({
          :purge => false
        })
      end

      it 'configures host' do
        is_expected.to contain_magnum_config('DEFAULT/host').with_value('<SERVICE DEFAULT>')
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__rabbit('magnum_config').with(
          :rabbit_ha_queues                => '<SERVICE DEFAULT>',
          :heartbeat_timeout_threshold     => '<SERVICE DEFAULT>',
          :heartbeat_rate                  => '<SERVICE DEFAULT>',
          :rabbit_qos_prefetch_count       => '<SERVICE DEFAULT>',
          :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
          :kombu_reconnect_delay           => '<SERVICE DEFAULT>',
          :kombu_failover_strategy         => '<SERVICE DEFAULT>',
          :kombu_ssl_version               => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile               => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile              => '<SERVICE DEFAULT>',
          :kombu_ssl_ca_certs              => '<SERVICE DEFAULT>',
          :amqp_durable_queues             => '<SERVICE DEFAULT>',
          :amqp_auto_delete                => '<SERVICE DEFAULT>',
          :kombu_compression               => '<SERVICE DEFAULT>',
          :rabbit_quorum_queue             => '<SERVICE DEFAULT>',
          :rabbit_transient_quorum_queue   => '<SERVICE DEFAULT>',
          :rabbit_transient_queues_ttl     => '<SERVICE DEFAULT>',
          :rabbit_quorum_delivery_limit    => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_length => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_bytes  => '<SERVICE DEFAULT>',
          :use_queue_manager               => '<SERVICE DEFAULT>',
          :rabbit_stream_fanout            => '<SERVICE DEFAULT>',
          :enable_cancel_on_failover       => '<SERVICE DEFAULT>',
        )
      end

      it 'configures notifications' do
        is_expected.to contain_oslo__messaging__notifications('magnum_config').with(
          :transport_url => '<SERVICE DEFAULT>',
          :driver        => '<SERVICE DEFAULT>',
          :topics        => '<SERVICE DEFAULT>',
          :retry         => '<SERVICE DEFAULT>',
        )
      end

    end

    context 'with overridden parameters' do
      let :params do
        { :package_ensure                     => 'latest',
          :host                               => 'localhost',
          :notification_transport_url         => 'rabbit://user:pass@host:1234/virt',
          :notification_topics                => 'openstack',
          :notification_driver                => 'messagingv1',
          :notification_retry                 => 10,
          :default_transport_url              => 'rabbit://user:pass@host:1234/virt',
          :rpc_response_timeout               => '120',
          :control_exchange                   => 'magnum',
          :kombu_failover_strategy            => 'shuffle',
          :rabbit_ha_queues                   => true,
          :rabbit_heartbeat_timeout_threshold => 60,
          :rabbit_heartbeat_rate              => 10,
          :rabbit_qos_prefetch_count          => 0,
          :amqp_durable_queues                => true,
          :amqp_auto_delete                   => true,
          :rabbit_quorum_queue                => true,
          :rabbit_transient_quorum_queue      => true,
          :rabbit_transient_queues_ttl        => 60,
          :rabbit_quorum_delivery_limit       => 3,
          :rabbit_quorum_max_memory_length    => 5,
          :rabbit_quorum_max_memory_bytes     => 1073741824,
          :rabbit_use_queue_manager           => true,
          :rabbit_stream_fanout               => true,
          :rabbit_enable_cancel_on_failover   => false,
        }
      end

      it 'installs packages' do
        is_expected.to contain_package('magnum-common').with(
          :ensure => 'latest',
          :name   => platform_params[:magnum_common_package],
          :tag    => ['openstack', 'magnum-package']
        )
      end

      it 'configures host' do
        is_expected.to contain_magnum_config('DEFAULT/host').with_value('localhost')
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__default('magnum_config').with(
          :transport_url        => 'rabbit://user:pass@host:1234/virt',
          :rpc_response_timeout => '120',
          :control_exchange     => 'magnum',
        )
        is_expected.to contain_oslo__messaging__rabbit('magnum_config').with(
          :rabbit_ha_queues                => true,
          :heartbeat_timeout_threshold     => 60,
          :heartbeat_rate                  => 10,
          :rabbit_qos_prefetch_count       => 0,
          :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
          :kombu_reconnect_delay           => '<SERVICE DEFAULT>',
          :kombu_failover_strategy         => 'shuffle',
          :kombu_ssl_version               => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile               => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile              => '<SERVICE DEFAULT>',
          :kombu_ssl_ca_certs              => '<SERVICE DEFAULT>',
          :amqp_durable_queues             => true,
          :amqp_auto_delete                => true,
          :kombu_compression               => '<SERVICE DEFAULT>',
          :rabbit_quorum_queue             => true,
          :rabbit_transient_quorum_queue   => true,
          :rabbit_transient_queues_ttl     => 60,
          :rabbit_quorum_delivery_limit    => 3,
          :rabbit_quorum_max_memory_length => 5,
          :rabbit_quorum_max_memory_bytes  => 1073741824,
          :use_queue_manager               => true,
          :rabbit_stream_fanout            => true,
          :enable_cancel_on_failover       => false,
        )
      end

      it 'configures notifications' do
        is_expected.to contain_oslo__messaging__notifications('magnum_config').with(
          :transport_url => 'rabbit://user:pass@host:1234/virt',
          :driver        => 'messagingv1',
          :topics        => 'openstack',
          :retry         => 10,
        )
      end
    end

    context 'with rabbit ssl enabled with kombu' do
      let :params do
        {
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '/etc/ca.crt',
          :kombu_ssl_certfile => '/etc/certfile',
          :kombu_ssl_keyfile  => '/etc/key',
          :kombu_ssl_version  => 'TLSv1',
        }
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__rabbit('magnum_config').with(
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '/etc/ca.crt',
          :kombu_ssl_certfile => '/etc/certfile',
          :kombu_ssl_keyfile  => '/etc/key',
          :kombu_ssl_version  => 'TLSv1',
        )
      end
    end

    context 'with rabbit ssl enabled without kombu' do
      let :params do
        {
          :rabbit_use_ssl     => 'true',
        }
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__rabbit('magnum_config').with(
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile  => '<SERVICE DEFAULT>',
          :kombu_ssl_version  => '<SERVICE DEFAULT>',
        )
      end
    end

    context 'with rabbit ssl disabled' do
      let :params do
        {
          :rabbit_use_ssl     => false,
        }
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__rabbit('magnum_config').with(
          :rabbit_use_ssl     => false,
          :kombu_ssl_ca_certs => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile  => '<SERVICE DEFAULT>',
          :kombu_ssl_version  => '<SERVICE DEFAULT>',
        )
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      let :platform_params do
        if facts[:os]['family'] == 'Debian'
          { :magnum_common_package => 'magnum-common' }
        else
          { :magnum_common_package => 'openstack-magnum-common' }
        end
      end

      it_behaves_like 'magnum'
    end

  end

end
