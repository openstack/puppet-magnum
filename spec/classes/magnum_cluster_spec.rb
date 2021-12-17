
require 'spec_helper'

describe 'magnum::cluster' do
  shared_examples 'magnum::cluster' do

    it 'contains default values' do
      is_expected.to contain_magnum_config('cluster/etcd_discovery_service_endpoint_format').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_magnum_config('cluster/nodes_affinity_policy').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_magnum_config('cluster/temp_cache_dir').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_magnum_config('cluster/pre_delete_lb_timeout').with_value('<SERVICE DEFAULT>')
    end

    context 'configure cluster with parameters' do
      let :params do
        {
          :etcd_discovery_service_endpoint_format => 'https://discovery.etcd.io/new?size=%(size)d',
          :nodes_affinity_policy                  => 'soft-anti-affinity',
          :temp_cache_dir                         => '/var/lib/magnum/certificate-cache',
          :pre_delete_lb_timeout                  => 60,
        }
      end

      it 'contains overrided values' do
        is_expected.to contain_magnum_config('cluster/etcd_discovery_service_endpoint_format').with_value('https://discovery.etcd.io/new?size=%(size)d')
        is_expected.to contain_magnum_config('cluster/nodes_affinity_policy').with_value('soft-anti-affinity')
        is_expected.to contain_magnum_config('cluster/temp_cache_dir').with_value('/var/lib/magnum/certificate-cache')
        is_expected.to contain_magnum_config('cluster/pre_delete_lb_timeout').with_value(60)
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

      it_behaves_like 'magnum::cluster'
    end
  end
end
