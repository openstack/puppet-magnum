require 'spec_helper'

describe 'magnum::clients::heat' do

  shared_examples 'magnum::clients::heat' do

    context 'with default parameters' do
      let :params do
        { :region_name     => 'RegionOne',
          :endpoint_type   => 'publicURL',
          :ca_file         => '<SERVICE DEFAULT>',
          :cert_file       => '<SERVICE DEFAULT>',
          :key_file        => '<SERVICE DEFAULT>',
          :insecure        => false,
        }
      end

      it { is_expected.to contain_magnum_config('heat_client/region_name').with_value('RegionOne') }
      it { is_expected.to contain_magnum_config('heat_client/endpoint_type').with_value('publicURL') }
      it { is_expected.to contain_magnum_config('heat_client/api_version').with_value('1') }
      it { is_expected.to contain_magnum_config('heat_client/ca_file').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('heat_client/cert_file').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('heat_client/key_file').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('heat_client/insecure').with_value(false) }
    end

    context 'with specific parameters' do
      let :params do
        { :region_name     => 'RegionTwo',
          :endpoint_type   => 'adminURL',
          :api_version     => '2',
          :ca_file         => '/etc/magnum/certs/ca.pem',
          :cert_file       => '/etc/magnum/certs/cert.pem',
          :key_file        => '/etc/magnum/certs/pri.key',
          :insecure        => true,
        }
      end

      it { is_expected.to contain_magnum_config('heat_client/region_name').with_value('RegionTwo') }
      it { is_expected.to contain_magnum_config('heat_client/endpoint_type').with_value('adminURL') }
      it { is_expected.to contain_magnum_config('heat_client/api_version').with_value('2') }
      it { is_expected.to contain_magnum_config('heat_client/ca_file').with_value('/etc/magnum/certs/ca.pem') }
      it { is_expected.to contain_magnum_config('heat_client/cert_file').with_value('/etc/magnum/certs/cert.pem') }
      it { is_expected.to contain_magnum_config('heat_client/key_file').with_value('/etc/magnum/certs/pri.key') }
      it { is_expected.to contain_magnum_config('heat_client/insecure').with_value(true) }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'magnum::clients::heat'
    end
  end
end
