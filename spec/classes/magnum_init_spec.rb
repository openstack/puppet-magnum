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
        is_expected.to contain_class('magnum::policy')
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

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__rabbit('magnum_config').with(
          :rabbit_ha_queues            => '<SERVICE DEFAULT>',
          :heartbeat_timeout_threshold => '<SERVICE DEFAULT>',
          :heartbeat_rate              => '<SERVICE DEFAULT>',
          :heartbeat_in_pthread        => '<SERVICE DEFAULT>',
          :rabbit_use_ssl              => '<SERVICE DEFAULT>',
          :kombu_reconnect_delay       => '<SERVICE DEFAULT>',
          :kombu_failover_strategy     => '<SERVICE DEFAULT>',
          :kombu_ssl_version           => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile           => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile          => '<SERVICE DEFAULT>',
          :kombu_ssl_ca_certs          => '<SERVICE DEFAULT>',
          :amqp_durable_queues         => '<SERVICE DEFAULT>',
          :kombu_compression           => '<SERVICE DEFAULT>')
      end

      it 'configures notifications' do
        is_expected.to contain_oslo__messaging__notifications('magnum_config').with(
          :transport_url => '<SERVICE DEFAULT>',
          :driver        => '<SERVICE DEFAULT>',
          :topics        => '<SERVICE DEFAULT>')
      end

    end

    context 'with overridden parameters' do
      let :params do
        { :package_ensure                     => 'latest',
          :notification_transport_url         => 'rabbit://user:pass@host:1234/virt',
          :notification_topics                => 'openstack',
          :notification_driver                => 'messagingv1',
          :default_transport_url              => 'rabbit://user:pass@host:1234/virt',
          :rpc_response_timeout               => '120',
          :control_exchange                   => 'magnum',
          :kombu_failover_strategy            => 'shuffle',
          :rabbit_ha_queues                   => true,
          :rabbit_heartbeat_timeout_threshold => 60,
          :rabbit_heartbeat_rate              => 10,
          :rabbit_heartbeat_in_pthread        => true,
          :amqp_durable_queues                => true,
        }
      end

      it 'installs packages' do
        is_expected.to contain_package('magnum-common').with(
          :ensure => 'latest',
          :name   => platform_params[:magnum_common_package],
          :tag    => ['openstack', 'magnum-package']
        )
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__default('magnum_config').with(
          :transport_url        => 'rabbit://user:pass@host:1234/virt',
          :rpc_response_timeout => '120',
          :control_exchange     => 'magnum',
        )
        is_expected.to contain_oslo__messaging__rabbit('magnum_config').with(
          :rabbit_ha_queues            => true,
          :heartbeat_timeout_threshold => 60,
          :heartbeat_rate              => 10,
          :heartbeat_in_pthread        => true,
          :rabbit_use_ssl              => '<SERVICE DEFAULT>',
          :kombu_reconnect_delay       => '<SERVICE DEFAULT>',
          :kombu_failover_strategy     => 'shuffle',
          :kombu_ssl_version           => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile           => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile          => '<SERVICE DEFAULT>',
          :kombu_ssl_ca_certs          => '<SERVICE DEFAULT>',
          :amqp_durable_queues         => true,
          :kombu_compression           => '<SERVICE DEFAULT>')
      end

      it 'configures notifications' do
        is_expected.to contain_oslo__messaging__notifications('magnum_config').with(
          :transport_url => 'rabbit://user:pass@host:1234/virt',
          :driver        => 'messagingv1',
          :topics        => 'openstack')
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
    context 'with default amqp parameters' do
      it 'configures amqp' do
        is_expected.to contain_oslo__messaging__amqp('magnum_config').with(
          :server_request_prefix  => '<SERVICE DEFAULT>',
          :broadcast_prefix       => '<SERVICE DEFAULT>',
          :group_request_prefix   => '<SERVICE DEFAULT>',
          :container_name         => '<SERVICE DEFAULT>',
          :idle_timeout           => '<SERVICE DEFAULT>',
          :trace                  => '<SERVICE DEFAULT>',
          :ssl_ca_file            => '<SERVICE DEFAULT>',
          :ssl_cert_file          => '<SERVICE DEFAULT>',
          :ssl_key_file           => '<SERVICE DEFAULT>',
          :ssl_key_password       => '<SERVICE DEFAULT>',
          :allow_insecure_clients => '<SERVICE DEFAULT>',
          :sasl_mechanisms        => '<SERVICE DEFAULT>',
          :sasl_config_dir        => '<SERVICE DEFAULT>',
          :sasl_config_name       => '<SERVICE DEFAULT>',
          :username               => '<SERVICE DEFAULT>',
          :password               => '<SERVICE DEFAULT>')
      end
    end

    context 'with overridden amqp parameters' do
      let :params do
        {  :default_transport_url => 'amqp://amqp_user:password@localhost:5672',
          :amqp_idle_timeout     => '60',
          :amqp_trace            => true,
          :amqp_ssl_ca_file      => '/etc/ca.cert',
          :amqp_ssl_cert_file    => '/etc/certfile',
          :amqp_ssl_key_file     => '/etc/key',
          :amqp_username         => 'amqp_user',
          :amqp_password         => 'password',
        }
      end

      it 'configures amqp' do
        is_expected.to contain_oslo__messaging__amqp('magnum_config').with(
          :server_request_prefix  => '<SERVICE DEFAULT>',
          :broadcast_prefix       => '<SERVICE DEFAULT>',
          :group_request_prefix   => '<SERVICE DEFAULT>',
          :container_name         => '<SERVICE DEFAULT>',
          :idle_timeout           => 60,
          :trace                  => 'true',
          :ssl_ca_file            => '/etc/ca.cert',
          :ssl_cert_file          => '/etc/certfile',
          :ssl_key_file           => '/etc/key',
          :ssl_key_password       => '<SERVICE DEFAULT>',
          :allow_insecure_clients => '<SERVICE DEFAULT>',
          :sasl_mechanisms        => '<SERVICE DEFAULT>',
          :sasl_config_dir        => '<SERVICE DEFAULT>',
          :sasl_config_name       => '<SERVICE DEFAULT>',
          :username               => 'amqp_user',
          :password               => 'password')
        is_expected.to contain_oslo__messaging__default('magnum_config').with(
          :transport_url        => 'amqp://amqp_user:password@localhost:5672')
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
        if facts[:osfamily] == 'Debian'
          { :magnum_common_package => 'magnum-common' }
        else
          { :magnum_common_package => 'openstack-magnum-common' }
        end
      end

      it_behaves_like 'magnum'
    end

  end

end
