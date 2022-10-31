require 'spec_helper'

describe 'magnum::cinder' do

  shared_examples 'magnum::cinder' do

    context 'with default parameters' do
      let :params do
        {}
      end

      it { is_expected.to contain_magnum_config('cinder/default_docker_volume_type').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('cinder/default_etcd_volume_type').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('cinder/default_boot_volume_type').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('cinder/default_boot_volume_size').with_value('<SERVICE DEFAULT>') }
    end

    context 'with specific parameters' do
      let :params do
        { :default_docker_volume_type => 'standard',
          :default_etcd_volume_type   => 'encrypted',
          :default_boot_volume_type   => 'fast',
          :default_boot_volume_size   => 5,
        }
      end

      it { is_expected.to contain_magnum_config('cinder/default_docker_volume_type').with_value('standard') }
      it { is_expected.to contain_magnum_config('cinder/default_etcd_volume_type').with_value('encrypted') }
      it { is_expected.to contain_magnum_config('cinder/default_boot_volume_type').with_value('fast') }
      it { is_expected.to contain_magnum_config('cinder/default_boot_volume_size').with_value('5') }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'magnum::cinder'
    end
  end
end
