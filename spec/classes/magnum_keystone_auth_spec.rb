require 'spec_helper'

describe 'magnum::keystone::auth' do
  shared_examples 'magnum::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        {
          :password => 'magnum_password',
          :tenant   => 'foobar'
        }
      end

      it { should contain_keystone_user('magnum').with(
        :ensure   => 'present',
        :password => 'magnum_password',
      )}

      it { should contain_keystone_user_role('magnum@foobar').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )}

      it { should contain_keystone_service('magnum::container-infra').with(
        :ensure      => 'present',
        :description => 'magnum Container Service'
      )}

      it { should contain_keystone_endpoint('RegionOne/magnum::container-infra').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1:9511/v1',
        :admin_url    => 'http://127.0.0.1:9511/v1',
        :internal_url => 'http://127.0.0.1:9511/v1',
      )}
    end

    context 'when overriding URL paramaters' do
      let :params do
        {
          :password     => 'magnum_password',
          :public_url   => 'https://10.10.10.10:80',
          :internal_url => 'http://10.10.10.11:81',
          :admin_url    => 'http://10.10.10.12:81',
        }
      end

      it { should contain_keystone_endpoint('RegionOne/magnum::container-infra').with(
        :ensure       => 'present',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81',
      )}
    end

    context 'when overriding auth name' do
      let :params do
        {
          :password => 'foo',
          :auth_name => 'magnumy'
        }
      end

      it { should contain_keystone_user('magnumy') }
      it { should contain_keystone_user_role('magnumy@services') }
      it { should contain_keystone_service('magnumy::container-infra') }
      it { should contain_keystone_endpoint('RegionOne/magnumy::container-infra') }
    end

    context 'when overriding service name' do
      let :params do
        {
          :service_name => 'magnum_service',
          :auth_name    => 'magnum',
          :password     => 'magnum_password'
        }
      end

      it { should contain_keystone_user('magnum') }
      it { should contain_keystone_user_role('magnum@services') }
      it { should contain_keystone_service('magnum_service::container-infra') }
      it { should contain_keystone_endpoint('RegionOne/magnum_service::container-infra') }
    end

    context 'when disabling user configuration' do
      let :params do
        {
          :password       => 'magnum_password',
          :configure_user => false
        }
      end

      it { should_not contain_keystone_user('magnum') }
      it { should contain_keystone_user_role('magnum@services') }

      it { should contain_keystone_service('magnum::container-infra').with(
        :ensure      => 'present',
        :type        => 'container-infra',
        :description => 'magnum Container Service'
      )}
    end

    context 'when disabling user and user role configuration' do
      let :params do
        {
          :password            => 'magnum_password',
          :configure_user      => false,
          :configure_user_role => false
        }
      end

      it { should_not contain_keystone_user('magnum') }
      it { should_not contain_keystone_user_role('magnum@services') }

      it { should contain_keystone_service('magnum::container-infra').with(
        :ensure      => 'present',
        :type        => 'container-infra',
        :description => 'magnum Container Service'
      )}
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
