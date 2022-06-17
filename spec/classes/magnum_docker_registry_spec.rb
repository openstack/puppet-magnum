
require 'spec_helper'

describe 'magnum::docker_registry' do
  shared_examples 'magnum::docker_registry' do

    it 'contains default values' do
      is_expected.to contain_magnum_config('docker_registry/swift_region').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_magnum_config('docker_registry/swift_registry_container').with_value('<SERVICE DEFAULT>')
    end

    context 'configure docker_registry with parameters' do
      let :params do
        {
          :swift_region             => 'regionOne',
          :swift_registry_container => 'docker_registry',
        }
      end

      it 'contains overridden values' do
        is_expected.to contain_magnum_config('docker_registry/swift_region').with_value('regionOne')
        is_expected.to contain_magnum_config('docker_registry/swift_registry_container').with_value('docker_registry')
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({}))
      end

      it_behaves_like 'magnum::docker_registry'
    end
  end
end
