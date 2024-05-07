
require 'spec_helper'

describe 'magnum::certificates' do
  shared_examples 'magnum::certificates' do

    it 'contains default values' do
      is_expected.to contain_magnum_config('certificates/cert_manager_type').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_magnum_config('certificates/storage_path').with_value('<SERVICE DEFAULT>')
    end

    context 'configure certificates with parameters' do
      let :params do
        {
          :cert_manager_type => 'barbican',
          :storage_path      => '/var/lib/magnum/certificates/',
        }
      end

      it 'contains overridden values' do
        is_expected.to contain_magnum_config('certificates/cert_manager_type').with_value('barbican')
        is_expected.to contain_magnum_config('certificates/storage_path').with_value('/var/lib/magnum/certificates/')
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

      it_behaves_like 'magnum::certificates'
    end
  end
end
