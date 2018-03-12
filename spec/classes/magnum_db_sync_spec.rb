require 'spec_helper'

describe 'magnum::db::sync' do

  shared_examples_for 'magnum-dbsync' do

    it 'runs magnum-db-sync' do
      is_expected.to contain_exec('magnum-db-sync').with(
        :command     => 'magnum-db-manage --config-file /etc/magnum/magnum.conf upgrade head',
        :path        => '/usr/bin',
        :user        => 'magnum',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[magnum::install::end]',
                         'Anchor[magnum::config::end]',
                         'Anchor[magnum::dbsync::begin]'],
        :notify      => 'Anchor[magnum::dbsync::end]',
        :tag         => 'openstack-db',
      )
    end

    describe "overriding extra_params" do
    let :params do
      {
        :extra_params => '--config-file /etc/magnum/magnum.conf',
      }
    end

    it {
        is_expected.to contain_exec('magnum-db-sync').with(
          :command     => 'magnum-db-manage --config-file /etc/magnum/magnum.conf upgrade head',
          :path        => '/usr/bin',
          :user        => 'magnum',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[magnum::install::end]',
                           'Anchor[magnum::config::end]',
                           'Anchor[magnum::dbsync::begin]'],
          :notify      => 'Anchor[magnum::dbsync::end]',
          :tag         => 'openstack-db',
        )
    }
    end

    describe "overriding exec_path" do
    let :params do
      {
        :exec_path => '/opt/venvs/magnum/bin',
      }
    end

    it {
        is_expected.to contain_exec('magnum-db-sync').with(
          :command     => 'magnum-db-manage --config-file /etc/magnum/magnum.conf upgrade head',
          :path        => '/opt/venvs/magnum/bin',
          :user        => 'magnum',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[magnum::install::end]',
                           'Anchor[magnum::config::end]',
                           'Anchor[magnum::dbsync::begin]'],
          :notify      => 'Anchor[magnum::dbsync::end]',
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
