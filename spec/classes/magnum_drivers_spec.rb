require 'spec_helper'

describe 'magnum::drivers' do

  shared_examples 'magnum::drivers' do

    context 'with default parameters' do
      let :params do
        {}
      end

      it { is_expected.to contain_magnum_config('drivers/verify_ca').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('drivers/openstack_ca_file').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('drivers/disabled_drivers').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('drivers/enabled_beta_drivers').with_value('<SERVICE DEFAULT>') }
    end

    context 'with specific parameters' do
      let :params do
        { :verify_ca                  => false,
          :openstack_ca_file          => '/tmp/cafile.pem',
          :disabled_drivers           => ['disabled_driver','anotherone'],
          :enabled_beta_drivers       => ['enabled_beta','enabled_beta2'],
        }
      end

      it { is_expected.to contain_magnum_config('drivers/verify_ca').with_value(false) }
      it { is_expected.to contain_magnum_config('drivers/openstack_ca_file').with_value('/tmp/cafile.pem') }
      it { is_expected.to contain_magnum_config('drivers/disabled_drivers').with_value('disabled_driver,anotherone') }
      it { is_expected.to contain_magnum_config('drivers/enabled_beta_drivers').with_value('enabled_beta,enabled_beta2') }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'magnum::drivers'
    end
  end
end
