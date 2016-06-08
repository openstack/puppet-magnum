require 'spec_helper'

describe 'magnum' do

  shared_examples 'magnum' do

    context 'with default parameters' do
      let :params do
        { :purge_config => false  }
      end

      it 'contains other classes' do
        is_expected.to contain_class('magnum::logging')
        is_expected.to contain_class('magnum::params')
        is_expected.to contain_class('magnum::policy')
        is_expected.to contain_class('magnum::db')
      end

      it 'installs packages' do
        is_expected.to contain_package('magnum-common').with(
          :name   => platform_params[:magnum_common_package],
          :ensure => 'present',
          :tag    => ['openstack', 'magnum-package']
        )
      end

      it 'creates various files and folders' do
        is_expected.to contain_file('/etc/magnum/magnum.conf').with(
          :require => 'Package[magnum-common]',
        )
      end

      it 'passes purge to resource' do
        is_expected.to contain_resources('magnum_config').with({
          :purge => false
        })
      end

      it 'configures rabbit' do
        is_expected.to contain_magnum_config('DEFAULT/rpc_backend').with_value('rabbit')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_host').with_value('<SERVICE_DEFAULT>')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_password').with_value('<SERVICE_DEFAULT>').with_secret(true)
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_port').with_value('<SERVICE_DEFAULT>')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_userid').with_value('<SERVICE_DEFAULT>')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_virtual_host').with_value('<SERVICE_DEFAULT>')
      end

      it 'configures various things' do
        is_expected.to contain_magnum_config('DEFAULT/notification_driver').with_value('<SERVICE_DEFAULT>')
      end

    end

    context 'with overridden parameters' do
      let :params do
        { :package_ensure      => 'latest',
          :notification_driver => 'messagingv1',
          :rabbit_host         => '53.210.103.65',
          :rabbit_port         => '1234',
          :rabbit_userid       => 'me',
          :rabbit_password     => 'secrete',
          :rabbit_virtual_host => 'vhost',
        }
      end

      it 'installs packages' do
        is_expected.to contain_package('magnum_common').with(
          :name   => platform_params[:magnum_common_package],
          :ensure => 'latest',
          :tag    => ['openstack', 'magnum-package']
        )
      end

      it 'configures rabbit' do
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_host').with_value('53.210.103.65')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_password').with_value('secrete').with_secret(true)
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_port').with_value('1234')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_userid').with_value('me')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_virtual_host').with_value('vhost')
      end

      it 'configures various things' do
        is_expected.to contain_magnum_config('DEFAULT/notification_driver').with_value('messagingv1')
      end
    end

    context 'with rabbit_hosts parameter' do
      let :params do
        { :rabbit_hosts => ['rabbit:5673', 'rabbit:5674'] }
      end

      it 'configures rabbit' do
        is_expected.to_not contain_magnum_config('oslo_messaging_rabbit/rabbit_host')
        is_expected.to_not contain_magnum_config('oslo_messaging_rabbit/rabbit_port')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_hosts').with_value('rabbit:5673,rabbit2:5674')
      end
    end

    context 'with rabbit_hosts parameter (one server)' do
      let :params do
        { :rabbit_hosts => ['rabbit:5673'] }
      end

      it 'configures rabbit' do
        is_expected.to_not contain_magnum_config('oslo_messaging_rabbit/rabbit_host')
        is_expected.to_not contain_magnum_config('oslo_messaging_rabbit/rabbit_port')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_hosts').with_value('rabbit:5673')
      end
    end

    context 'with rabbit ssl enabled with kombu' do
      let :params do
        { :rabbit_hosts       => ['rabbit:5673'],
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '/etc/ca.crt',
          :kombu_ssl_certfile => '/etc/certfile',
          :kombu_ssl_keyfile  => '/etc/key',
          :kombu_ssl_version  => 'TLSv1',
        }
      end

      it 'configures rabbit' do
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value(true)
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('/etc/ca.cert')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('/etc/certfile')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('/etc/key')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('TLSv1')
      end
    end

    context 'with rabbit ssl enabled without kombu' do
      let :params do
        { :rabbit_hosts       => ['rabbit:5673'],
          :rabbit_use_ssl     => 'true',
        }
      end

      it 'configures rabbit' do
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value(true)
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('<SERVICE_DEFAULT>')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('<SERVICE_DEFAULT>')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('<SERVICE_DEFAULT>')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('<SERVICE_DEFAULT>')
      end
    end

    context 'with rabbit ssl disabled' do
      let :params do
        { :rabbit_password    => 'pass',
          :rabbit_use_ssl     => false,
          :kombu_ssl_version  => 'TLSv1',
        }
      end

      it 'configures rabbit' do
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value('false')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('<SERVICE_DEFAULT>')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('<SERVICE_DEFAULT>')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('<SERVICE_DEFAULT>')
        is_expected.to contain_magnum_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('<SERVICE_DEFULT>')
      end
    end

    on_supported_os({
      :supported_os => OSDefaults.get_supported_os
    }).each do |os,facts|
      context "on #{os}" do
        let (:facts) do
          facts.merge(OSDefaults.get_facts({:processorcount => 8}))
        end

        let :platform_params do
          if facts[:os_family] == 'Debian'
            { :magnum_common_package => 'magnum-common' }
          else
            { :magnum_common_package => 'openstack-magnum-common' }
          end
        end

        it_behaves_like 'magnum'
      end

    end

  end

end
