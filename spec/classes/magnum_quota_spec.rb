
require 'spec_helper'

describe 'magnum::quota' do
  let :default_params do
    {
      :max_clusters_per_project => '<SERVICE DEFAULT>',
    }
  end

  let :params do
    {}
  end

  shared_examples 'magnum quota' do

    let :p do
      default_params.merge(params)
    end

    it 'contains default values' do
      is_expected.to contain_magnum_config('quotas/max_clusters_per_project').with_value(p[:max_clusters_per_project])
    end

    context 'configure quota with parameters' do
      before :each do
        params.merge!({ :max_clusters_per_project => 10 })
      end

      it 'contains overridden values' do
        is_expected.to contain_magnum_config('quotas/max_clusters_per_project').with_value(p[:max_clusters_per_project])
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

      it_behaves_like 'magnum quota'
    end
  end
end
