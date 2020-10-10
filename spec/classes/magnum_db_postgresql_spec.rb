require 'spec_helper'

describe 'magnum::db::postgresql' do

  shared_examples_for 'magnum::db::postgresql' do
    let :req_params do
      { :password => 'magnumpass' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_class('magnum::deps') }

      it { is_expected.to contain_openstacklib__db__postgresql('magnum').with(
        :user       => 'magnum',
        :password   => 'magnumpass',
        :dbname     => 'magnum',
        :encoding   => nil,
        :privileges => 'ALL',
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'magnum::db::postgresql'
    end
  end

end
