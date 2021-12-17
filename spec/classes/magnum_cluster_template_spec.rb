require 'spec_helper'

describe 'magnum::cluster_template' do
  shared_examples 'magnum::cluster_template' do

    it 'contains default values' do
      is_expected.to contain_magnum_config('cluster_template/kubernetes_allowed_network_drivers').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_magnum_config('cluster_template/kubernetes_default_network_driver').with_value('<SERVICE DEFAULT>')
    end

    context 'configure cluster_template with parameters' do
      let :params do
        {
          :kubernetes_allowed_network_drivers => ['all'],
          :kubernetes_default_network_driver  => 'flannel',
        }
      end

      it 'contains overrided values' do
        is_expected.to contain_magnum_config('cluster_template/kubernetes_allowed_network_drivers').with_value('all')
        is_expected.to contain_magnum_config('cluster_template/kubernetes_default_network_driver').with_value('flannel')
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

      it_behaves_like 'magnum::cluster_template'
    end
  end
end
