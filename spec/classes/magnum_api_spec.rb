#
# Unit tests for magnum::api
#
require 'spec_helper'

describe 'magnum::api' do

  let :pre_condition do
    'class { "magnum::keystone::authtoken": password => "secret", }'
  end

  let :default_params do
    { :package_ensure               => 'present',
      :enabled                      => true,
      :port                         => '9511',
      :host                         => '127.0.0.1',
      :max_limit                    => '1000',
      :sync_db                      => 'true',
      :enabled_ssl                  => 'false',
      :ssl_cert_file                => '<SERVICE DEFAULT>',
      :ssl_key_file                 => '<SERVICE DEFAULT>',
      :enable_proxy_headers_parsing => '<SERVICE DEFAULT>',
    }
  end

  let :params do
    {}
  end

  shared_examples_for 'magnum-api' do
    let :p do
      default_params.merge(params)
    end

    it { is_expected.to contain_class('magnum::deps') }
    it { is_expected.to contain_class('magnum::params') }
    it { is_expected.to contain_class('magnum::policy') }

    it 'configures magnum api package' do
      is_expected.to contain_package('magnum-api').with(
        :ensure => p[:package_ensure],
        :name   => platform_params[:api_package],
        :tag    => ['openstack', 'magnum-package'],
      )
    end

    it 'ensures magnum api service is running' do
      is_expected.to contain_service('magnum-api').with(
        'hasstatus' => true,
        'tag'       => ['magnum-service', 'magnum-db-sync-service']
      )
    end

    it 'configures magnum.conf' do
      is_expected.to contain_magnum_config('api/port').with_value(p[:port])
      is_expected.to contain_magnum_config('api/host').with_value(p[:host])
      is_expected.to contain_magnum_config('api/max_limit').with_value(p[:max_limit])
      is_expected.to contain_magnum_config('api/enabled_ssl').with_value(p[:enabled_ssl])
      is_expected.to contain_magnum_config('api/ssl_cert_file').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_magnum_config('api/ssl_key_file').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_magnum_config('api/workers').with_value(facts[:os_workers])
    end

    it { is_expected.to contain_oslo__middleware('magnum_config').with(
      :enable_proxy_headers_parsing => '<SERVICE DEFAULT>',
    )}

    context 'when overriding parameters' do
      before :each do
        params.merge!(
          :port         => '1234',
          :host         => '0.0.0.0',
          :max_limit    => '10',
          :workers      => 10,
        )
      end

      it 'should replace default parameters with new values' do
        is_expected.to contain_magnum_config('api/port').with_value(p[:port])
        is_expected.to contain_magnum_config('api/host').with_value(p[:host])
        is_expected.to contain_magnum_config('api/max_limit').with_value(p[:max_limit])
        is_expected.to contain_magnum_config('api/workers').with_value(p[:workers])
      end
    end

    context 'with SSL enabled' do
      let :params do
        {
          :enabled_ssl   => true,
          :ssl_cert_file => '/path/to/cert',
          :ssl_key_file  => '/path/to/key'
        }
      end

      it { is_expected.to contain_magnum_config('api/enabled_ssl').with_value(p[:enabled_ssl]) }
      it { is_expected.to contain_magnum_config('api/ssl_cert_file').with_value(p[:ssl_cert_file]) }
      it { is_expected.to contain_magnum_config('api/ssl_key_file').with_value(p[:ssl_key_file]) }
    end

    context 'with oslo_middleware configured' do
      let :params do
        {
          :enable_proxy_headers_parsing => true,
        }
      end

      it { is_expected.to contain_oslo__middleware('magnum_config').with(
        :enable_proxy_headers_parsing => 'true',
      )}
    end
  end

  shared_examples 'magnum-api wsgi' do
    let :pre_condition do
      "include magnum
       class { 'magnum::keystone::authtoken':
         password => 'secret',
       }
       include apache"
    end

    let :params do
      {
        :service_name => 'httpd',
      }
    end

    context 'with required params' do
      it { should contain_service('magnum-api').with(
        :ensure    => 'stopped',
        :name      => platform_params[:api_service],
        :enable    => false,
        :hasstatus => true,
        :tag       => ['magnum-service', 'magnum-db-sync-service'],
      )}
    end
  end

 on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :api_package => 'magnum-api',
            :api_service => 'magnum-api' }
        when 'RedHat'
          { :api_package => 'openstack-magnum-api',
            :api_service => 'openstack-magnum-api' }
        end
      end

      it_configures 'magnum-api'
      it_configures 'magnum-api wsgi'
    end

  end

end
