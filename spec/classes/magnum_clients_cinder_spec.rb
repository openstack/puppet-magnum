require 'spec_helper'

describe 'magnum::clients::cinder' do

  shared_examples 'magnum::clients::cinder' do

    context 'with default parameters' do
      let :params do
        { :region_name     => 'RegionOne',
        }
      end

      it { is_expected.to contain_magnum_config('cinder_client/region_name').with_value('RegionOne') }
    end

    context 'with specific parameters' do
      let :params do
        { :region_name     => 'RegionTwo',
        }
      end

      it { is_expected.to contain_magnum_config('cinder_client/region_name').with_value('RegionTwo') }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'magnum::clients::cinder'
    end
  end
end
