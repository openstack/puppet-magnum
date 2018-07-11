require 'spec_helper'

describe 'magnum' do

  shared_examples 'magnum' do

    context 'with default parameters' do
      let :params do
        { :purge_config => false  }
      end

      it 'contains other classes' do
        is_expected.to contain_class('magnum::logging')
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
        is_expected.to contain_magnum_config('DEFAULT/transport_url').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('DEFAULT/rpc_response_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('DEFAULT/control_exchange').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/kombu_failover_strategy').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/heartbeat_rate').with_value('<SERVICE DEFAULT>')
      end

      it 'configures various things' do
        is_expected.to contain_magnum_config('oslo_messaging_notifications/transport_url').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('oslo_messaging_notifications/driver').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('oslo_messaging_notifications/topics').with_value('<SERVICE DEFAULT>')
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
        is_expected.to contain_magnum_config('DEFAULT/transport_url').with_value('rabbit://user:pass@host:1234/virt')
        is_expected.to contain_magnum_config('DEFAULT/rpc_response_timeout').with_value('120')
        is_expected.to contain_magnum_config('DEFAULT/control_exchange').with_value('magnum')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/kombu_failover_strategy').with_value('shuffle')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value(true)
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value(60)
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/heartbeat_rate').with_value(10)
      end

      it 'configures various things' do
        is_expected.to contain_magnum_config('oslo_messaging_notifications/transport_url').with_value('rabbit://user:pass@host:1234/virt')
        is_expected.to contain_magnum_config('oslo_messaging_notifications/driver').with_value('messagingv1')
        is_expected.to contain_magnum_config('oslo_messaging_notifications/topics').with_value('openstack')
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
