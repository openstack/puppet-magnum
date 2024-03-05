require 'spec_helper'

describe 'magnum::db::sync' do

  shared_examples_for 'magnum-dbsync' do

    it { is_expected.to contain_class('magnum::deps') }

    it 'runs magnum-db-sync' do
      is_expected.to contain_exec('magnum-db-sync').with(
        :command     => 'magnum-db-manage  upgrade head',
        :path        => ['/bin', '/usr/bin'],
        :user        => 'magnum',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :timeout     => 300,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[magnum::install::end]',
                         'Anchor[magnum::config::end]',
                         'Anchor[magnum::dbsync::begin]'],
        :notify      => 'Anchor[magnum::dbsync::end]',
        :tag         => 'openstack-db',
      )
    end

    describe "overriding params" do
      let :params do
        {
          :extra_params    => '--config-file /etc/magnum/magnum.conf',
          :db_sync_timeout => 750,
        }
      end

      it {
        is_expected.to contain_exec('magnum-db-sync').with(
          :command     => 'magnum-db-manage --config-file /etc/magnum/magnum.conf upgrade head',
          :path        => ['/bin', '/usr/bin'],
          :user        => 'magnum',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :timeout     => 750,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[magnum::install::end]',
                           'Anchor[magnum::config::end]',
                           'Anchor[magnum::dbsync::begin]'],
          :notify      => 'Anchor[magnum::dbsync::end]',
          :tag         => 'openstack-db',
        )
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

      it_configures 'magnum-dbsync'
    end

  end

end
