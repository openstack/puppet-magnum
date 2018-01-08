require 'spec_helper'

describe 'magnum::clients::barbican' do

  shared_examples 'magnum::clients::barbican' do

    context 'with default parameters' do
      let :params do
        { :region_name     => 'RegionOne',
          :endpoint_type   => 'publicURL',
        }
      end

      it { is_expected.to contain_magnum_config('barbican_client/region_name').with_value('RegionOne') }
      it { is_expected.to contain_magnum_config('barbican_client/endpoint_type').with_value('publicURL') }
    end

    context 'with specific parameters' do
      let :params do
        { :region_name     => 'RegionTwo',
          :endpoint_type   => 'adminURL',
        }
      end

      it { is_expected.to contain_magnum_config('barbican_client/region_name').with_value('RegionTwo') }
      it { is_expected.to contain_magnum_config('barbican_client/endpoint_type').with_value('adminURL') }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'magnum::clients::barbican'
    end
  end
end
