#
# Unit tests for magnum::keystone::auth
#

require 'spec_helper'

describe 'magnum::keystone::auth' do

  let :facts do
    OSDefaults.get_facts({ :osfamily => 'Debian' })
  end

  describe 'with default class parameters' do
    let :params do
      { :password => 'magnum_password',
        :tenant   => 'foobar' }
    end

    it { is_expected.to contain_keystone_user('magnum').with(
      :ensure   => 'present',
      :password => 'magnum_password',
    ) }

    it { is_expected.to contain_keystone_user_role('magnum@foobar').with(
      :ensure  => 'present',
      :roles   => ['admin']
    )}

    it { is_expected.to contain_keystone_service('magnum::container').with(
      :ensure      => 'present',
      :description => 'magnum Container Service'
    ) }

    it { is_expected.to contain_keystone_endpoint('RegionOne/magnum::container').with(
      :ensure       => 'present',
      :public_url   => 'http://127.0.0.1:9511/v1',
      :admin_url    => 'http://127.0.0.1:9511/v1',
      :internal_url => 'http://127.0.0.1:9511/v1',
    ) }
  end

  describe 'when overriding URL paramaters' do
    let :params do
      { :password     => 'magnum_password',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81', }
    end

    it { is_expected.to contain_keystone_endpoint('RegionOne/magnum::container').with(
      :ensure       => 'present',
      :public_url   => 'https://10.10.10.10:80',
      :internal_url => 'http://10.10.10.11:81',
      :admin_url    => 'http://10.10.10.12:81',
    ) }
  end

  describe 'when overriding auth name' do
    let :params do
      { :password => 'foo',
        :auth_name => 'magnumy' }
    end

    it { is_expected.to contain_keystone_user('magnumy') }
    it { is_expected.to contain_keystone_user_role('magnumy@services') }
    it { is_expected.to contain_keystone_service('magnumy::container') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/magnumy::container') }
  end

  describe 'when overriding service name' do
    let :params do
      { :service_name => 'magnum_service',
        :auth_name    => 'magnum',
        :password     => 'magnum_password' }
    end

    it { is_expected.to contain_keystone_user('magnum') }
    it { is_expected.to contain_keystone_user_role('magnum@services') }
    it { is_expected.to contain_keystone_service('magnum_service::container') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/magnum_service::container') }
  end

  describe 'when disabling user configuration' do

    let :params do
      {
        :password       => 'magnum_password',
        :configure_user => false
      }
    end

    it { is_expected.not_to contain_keystone_user('magnum') }
    it { is_expected.to contain_keystone_user_role('magnum@services') }
    it { is_expected.to contain_keystone_service('magnum::container').with(
      :ensure      => 'present',
      :type        => 'container',
      :description => 'magnum Container Service'
    ) }

  end

  describe 'when disabling user and user role configuration' do

    let :params do
      {
        :password            => 'magnum_password',
        :configure_user      => false,
        :configure_user_role => false
      }
    end

    it { is_expected.not_to contain_keystone_user('magnum') }
    it { is_expected.not_to contain_keystone_user_role('magnum@services') }
    it { is_expected.to contain_keystone_service('magnum::container').with(
      :ensure      => 'present',
      :type        => 'container',
      :description => 'magnum Container Service'
    ) }

  end

end
