require 'spec_helper'

describe 'magnum::healthcheck' do

  shared_examples_for 'magnum::healthcheck' do

    context 'with default parameters' do
      let :params do
        {}
      end

      it 'configures default values' do
        is_expected.to contain_oslo__healthcheck('magnum_config').with(
          :detailed              => '<SERVICE DEFAULT>',
          :backends              => '<SERVICE DEFAULT>',
          :disable_by_file_path  => '<SERVICE DEFAULT>',
          :disable_by_file_paths => '<SERVICE DEFAULT>',
        )
      end
    end

    context 'with specific parameters' do
      let :params do
        {
          :detailed              => true,
          :backends              => ['disable_by_file'],
          :disable_by_file_path  => '/etc/magnum/healthcheck/disabled',
          :disable_by_file_paths => ['9511:/etc/magnum/healthcheck/disabled'],
        }
      end

      it 'configures specified values' do
        is_expected.to contain_oslo__healthcheck('magnum_config').with(
          :detailed              => true,
          :backends              => ['disable_by_file'],
          :disable_by_file_path  => '/etc/magnum/healthcheck/disabled',
          :disable_by_file_paths => ['9511:/etc/magnum/healthcheck/disabled'],
        )
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

      it_configures 'magnum::healthcheck'
    end
  end

end
