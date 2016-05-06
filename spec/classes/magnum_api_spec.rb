#
# Unit tests for magnum::api
#
require 'spec_helper'

describe 'magnum::api' do

  let :default_params do
    { :package_ensure    => 'present',
      :enabled           => true,
      :port              => '9511',
      :host              => '127.0.0.1',
      :max_limit         => '1000',
      :auth_uri          => 'http://127.0.0.1:5000/',
      :identity_uri      => 'http://127.0.0.1:35357/',
      :sync_db           => 'true',
      :admin_tenant_name => 'services',
      :admin_user        => 'magnum',
    }
  end

  let :params do
    { :admin_password => 'secrete' }
  end

  shared_examples_for 'magnum-api' do
    let :p do
      default_params.merge(params)
    end

    it { is_expected.to contain_class('magnum::params') }
    it { is_expected.to contain_class('magnum::policy') }

    it 'configures magnum api package' do
      if platform_params.has_key?(:api_package)
        is_expected.to contain_package('magnum-api').with(
          :ensure => p[:package_ensure],
          :name   => platform_params[:api_package],
          :tag    => ['openstack', 'magnum-package'],
        )
        is_expected.to contain_package('magnum-api').with_before(/Service\[magnum-api\]/)
      end
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
      is_expected.to contain_magnum_config('keystone_authtoken/admin_password').with_value(p[:admin_password]).with_secret(true)
      is_expected.to contain_magnum_config('keystone_authtoken/admin_user').with_value(p[:admin_user])
      is_expected.to contain_magnum_config('keystone_authtoken/admin_tenant_name').with_value(p[:admin_tenant_name])
      is_expected.to contain_magnum_config('keystone_authtoken/auth_uri').with_value(p[:auth_uri])
      is_expected.to contain_magnum_config('keystone_authtoken/identity_uri').with_value(p[:identity_uri])
    end

    context 'when overriding parameters' do
      before :each do
        params.merge!(
          :port         => '1234',
          :host         => '0.0.0.0',
          :max_limit    => '10',
          :auth_uri     => 'http://127.0.0.1:5000/',
          :identity_uri => 'http://127.0.0.1:35357/',
        )
      end

      it 'should replace default parameters with new values' do
        is_expected.to contain_magnum_config('api/port').with_value(p[:port])
        is_expected.to contain_magnum_config('api/host').with_value(p[:host])
        is_expected.to contain_magnum_config('api/max_limit').with_value(p[:max_limit])
        is_expected.to contain_magnum_config('keystone_authtoken/admin_password').with_value(p[:admin_password]).with_secret(true)
        is_expected.to contain_magnum_config('keystone_authtoken/admin_user').with_value(p[:admin_user])
        is_expected.to contain_magnum_config('keystone_authtoken/admin_tenant_name').with_value(p[:admin_tenant_name])
        is_expected.to contain_magnum_config('keystone_authtoken/auth_uri').with_value(p[:auth_uri])
        is_expected.to contain_magnum_config('keystone_authtoken/identity_uri').with_value(p[:identity_uri])
      end
    end

  end

 on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let :platform_params do
      { :api_service => 'magnum-api' }
      end

      it_configures 'magnum-api'
    end

  end

end
