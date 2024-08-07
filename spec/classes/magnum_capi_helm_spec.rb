require 'spec_helper'

describe 'magnum::capi_helm' do

  shared_examples 'magnum::capi_helm' do

    context 'with default parameters' do
      let :params do
        {}
      end
      it { is_expected.to contain_magnum_config('capi_helm/kubeconfig_file').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('capi_helm/namespace_prefix').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('capi_helm/helm_chart_repo').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('capi_helm/helm_chart_name').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('capi_helm/default_helm_chart_version').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('capi_helm/minimum_flavor_ram').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('capi_helm/minimum_flavor_vcpus').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('capi_helm/csi_cinder_default_volume_type').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('capi_helm/csi_cinder_reclaim_policy').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('capi_helm/csi_cinder_allow_volume_expansion').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('capi_helm/csi_cinder_allowed_topologies').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('capi_helm/csi_cinder_fstype').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('capi_helm/csi_cinder_volume_binding_mode').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('capi_helm/csi_cinder_availability_zone').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('capi_helm/app_cred_interface_type').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to_not contain_file('<SERVICE DEFAULT>') }

    end

    context 'with specific parameters' do
      let :params do
        { 
          :kubeconfig_file                   => '/tmp/kubeconfig.yaml',
          :kubeconfig                        => { 'setting' => 'blah' },
          :kubeconfig_owner                  => 'anowner',
          :kubeconfig_group                  => 'agroup',
          :kubeconfig_mode                   => '0666',
          :namespace_prefix                  => 'aprefix',
          :helm_chart_repo                   => 'my-chart-repo',
          :helm_chart_name                   => 'my-helm-chart-name',
          :default_helm_chart_version        => 'v42',
          :minimum_flavor_ram                => 42,
          :minimum_flavor_vcpus              => 8,
          :csi_cinder_default_volume_type    => 'my-cinder-type',
          :csi_cinder_reclaim_policy         => 'my-cinder-poilicy',
          :csi_cinder_allow_volume_expansion => true,
          :csi_cinder_allowed_topologies     => ['topo1','topo2'],
          :csi_cinder_fstype                 => 'ext3',
          :csi_cinder_volume_binding_mode    => 'bind-mode',
          :csi_cinder_availability_zone      => 'cinder-zone',
          :app_cred_interface_type           => 'app-cred-int-type',
        }
      end

      it { is_expected.to contain_magnum_config('capi_helm/kubeconfig_file').with_value('/tmp/kubeconfig.yaml') }
      it { is_expected.to contain_magnum_config('capi_helm/namespace_prefix').with_value('aprefix') }
      it { is_expected.to contain_magnum_config('capi_helm/helm_chart_repo').with_value('my-chart-repo') }
      it { is_expected.to contain_magnum_config('capi_helm/helm_chart_name').with_value('my-helm-chart-name') }
      it { is_expected.to contain_magnum_config('capi_helm/default_helm_chart_version').with_value('v42') }
      it { is_expected.to contain_magnum_config('capi_helm/minimum_flavor_ram').with_value(42) }
      it { is_expected.to contain_magnum_config('capi_helm/minimum_flavor_vcpus').with_value(8) }
      it { is_expected.to contain_magnum_config('capi_helm/csi_cinder_default_volume_type').with_value('my-cinder-type') }
      it { is_expected.to contain_magnum_config('capi_helm/csi_cinder_reclaim_policy').with_value('my-cinder-poilicy') }
      it { is_expected.to contain_magnum_config('capi_helm/csi_cinder_allow_volume_expansion').with_value(true) }
      it { is_expected.to contain_magnum_config('capi_helm/csi_cinder_allowed_topologies').with_value('topo1,topo2') }
      it { is_expected.to contain_magnum_config('capi_helm/csi_cinder_fstype').with_value('ext3') }
      it { is_expected.to contain_magnum_config('capi_helm/csi_cinder_volume_binding_mode').with_value('bind-mode') }
      it { is_expected.to contain_magnum_config('capi_helm/csi_cinder_availability_zone').with_value('cinder-zone') }
      it { is_expected.to contain_magnum_config('capi_helm/app_cred_interface_type').with_value('app-cred-int-type') }

      it { is_expected.to contain_file('/tmp/kubeconfig.yaml')
         .with_owner('anowner')
         .with_group('agroup')
         .with_mode('0666')
      }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'magnum::capi_helm'
    end
  end
end
