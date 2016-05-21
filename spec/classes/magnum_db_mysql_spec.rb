require 'spec_helper'

describe 'magnum::db::mysql' do
  shared_examples_for 'magnum::db::mysql' do

    let :pre_condition do
      [
        'include mysql::server',
        'include magnum::db::sync'
      ]
    end

    let :params do
      {
        'password'      => 'secrete',
      }
    end

    context 'with only required params' do
      it { is_expected.to contain_openstacklib__db__mysql('magnum').with(
        :user          => 'magnum',
        :password_hash => '*FBA9D2346613CFE4A811FC2A4A648432C6FA2CFD',
        :dbname        => 'magnum',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
      )}
    end

    context "overriding allowed_hosts param to array" do
      let :params do
        {
          :password       => 'secrete',
          :allowed_hosts  => ['127.0.0.1','%'],
        }
      end

      it { is_expected.to contain_openstacklib__db__mysql('magnum').with(
        :user          => 'magnum',
        :password_hash => '*FBA9D2346613CFE4A811FC2A4A648432C6FA2CFD',
        :dbname        => 'magnum',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => ['127.0.0.1', '%'],
      )}

    end

    context "overriding allowed_hosts param to string" do
      let :params do
        {
          :password       => 'secrete',
          :allowed_hosts  => '192.168.1.1',
        }
      end

      it { is_expected.to contain_openstacklib__db__mysql('magnum').with(
        :user          => 'magnum',
        :password_hash => '*FBA9D2346613CFE4A811FC2A4A648432C6FA2CFD',
        :dbname        => 'magnum',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => '192.168.1.1',
      )}

    end

    context "overriding allowed_hosts equal to host param" do
      let :params do
        {
          :password      => 'secrete',
          :allowed_hosts => '127.0.0.1',
        }
      end

      it { is_expected.to contain_openstacklib__db__mysql('magnum').with(
        :user          => 'magnum',
        :password_hash => '*FBA9D2346613CFE4A811FC2A4A648432C6FA2CFD',
        :dbname        => 'magnum',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => '127.0.0.1',
      )}

    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "os #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'magnum::db::mysql'
    end
  end
end
