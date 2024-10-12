#
# Unit tests for magnum::keystone::auth
#

require 'spec_helper'

describe 'magnum::keystone::auth' do
  shared_examples_for 'magnum::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'magnum_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('magnum').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :configure_service   => true,
        :service_name        => 'magnum',
        :service_type        => 'container-infra',
        :service_description => 'magnum Container Service',
        :region              => 'RegionOne',
        :auth_name           => 'magnum',
        :password            => 'magnum_password',
        :email               => 'magnum@localhost',
        :tenant              => 'services',
        :roles               => ['admin'],
        :system_scope        => 'all',
        :system_roles        => [],
        :public_url          => 'http://127.0.0.1:9511/v1',
        :internal_url        => 'http://127.0.0.1:9511/v1',
        :admin_url           => 'http://127.0.0.1:9511/v1',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'magnum_password',
          :auth_name           => 'alt_magnum',
          :email               => 'alt_magnum@alt_localhost',
          :tenant              => 'alt_service',
          :roles               => ['admin', 'service'],
          :system_scope        => 'alt_all',
          :system_roles        => ['admin', 'member', 'reader'],
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :configure_service   => false,
          :service_description => 'Alternative magnum Container Service',
          :service_name        => 'alt_service',
          :service_type        => 'alt_container-infra',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('magnum').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :configure_service   => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_container-infra',
        :service_description => 'Alternative magnum Container Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_magnum',
        :password            => 'magnum_password',
        :email               => 'alt_magnum@alt_localhost',
        :tenant              => 'alt_service',
        :roles               => ['admin', 'service'],
        :system_scope        => 'alt_all',
        :system_roles        => ['admin', 'member', 'reader'],
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'magnum::keystone::auth'
    end
  end
end
