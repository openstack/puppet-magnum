require 'spec_helper'

describe 'magnum::client' do
  shared_examples_for 'magnum client' do
    it { is_expected.to contain_class('magnum::deps') }
    it { is_expected.to contain_class('magnum::params') }

    it 'installs magnum client package' do
      is_expected.to contain_package('python-magnumclient').with(
        :ensure => 'present',
        :name   => platform_params[:client_package_name],
        :tag    => 'openstack',
      )
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :client_package_name => 'python3-magnumclient' }
        when 'RedHat'
          if facts[:operatingsystem] == 'Fedora'
            { :client_package_name => 'python3-magnumclient' }
          else
            if facts[:operatingsystemmajrelease] > '7'
              { :client_package_name => 'python3-magnumclient' }
            else
              { :client_package_name => 'python-magnumclient' }
            end
          end
        end
      end

      it_configures 'magnum client'
    end
  end
end
