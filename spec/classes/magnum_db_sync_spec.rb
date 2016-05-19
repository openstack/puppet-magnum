require 'spec_helper'

describe 'magnum::db::sync' do

  shared_examples_for 'magnum-dbsync' do

    it 'runs magnum-db-sync' do
      is_expected.to contain_exec('magnum-db-sync').with(
        :command     => 'magnum-db-manage --config-file /etc/magnum/magnum.conf upgrade head',
        :path        => '/usr/bin',
        :user        => 'magnum',
        :refreshonly => 'true',
        :logoutput   => 'on_failure'
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
          :logoutput   => 'on_failure'
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
