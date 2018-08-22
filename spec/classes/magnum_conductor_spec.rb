#
# Unit tests for magnum::conductor
#
require 'spec_helper'

describe 'magnum::conductor' do

  let :pre_condition do
    'include magnum'
  end

  shared_examples_for 'magnum-conductor' do

    it { is_expected.to contain_package('magnum-conductor').with(
      :name   => platform_params[:conductor_package],
      :ensure => 'present'
    ) }

    it { is_expected.to contain_service('magnum-conductor').with(
      :name      => platform_params[:conductor_service],
      :hasstatus => 'true',
      :ensure    => 'running'
    ) }

    it {
      is_expected.to contain_magnum_config('conductor/conductor_life_check_timeout').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_magnum_config('conductor/workers').with_value(facts[:os_workers])
    }

    context 'with conductor_life_check_timeout specified' do
      let :params do
        { :conductor_life_check_timeout => '4' }
      end

      it { is_expected.to contain_magnum_config('conductor/conductor_life_check_timeout').with_value('4') }
    end

    context 'with manage_service as false' do
      let :params do
        { :enabled        => true,
          :manage_service => false
        }
      end
      it { is_expected.to contain_service('magnum-conductor').without_ensure }
    end

    context 'with workers specified' do
      let :params do
        { :workers => 10 }
      end

      it { is_expected.to contain_magnum_config('conductor/workers').with_value(10) }
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
          { :conductor_package => 'magnum-conductor',
            :conductor_service => 'magnum-conductor' }
        else
          { :conductor_package => 'openstack-magnum-conductor',
            :conductor_service => 'openstack-magnum-conductor' }
        end
      end

      it_configures 'magnum-conductor'
    end
  end
end
