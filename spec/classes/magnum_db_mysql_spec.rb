require 'spec_helper'

describe 'magnum::db::mysql' do

  let :pre_condition do
    [
      'include mysql::server',
      'include magnum::db::sync'
    ]
  end

  let :facts do
    @default_facts.merge({ :osfamily => 'Debian' })
  end

  let :params do
    {
      'password'      => 'secrete',
    }
  end

  describe 'with only required params' do
    it { is_expected.to contain_openstacklib__db__mysql('magnum').with(
      :user          => 'magnum',
      :password_hash => '*FBA9D2346613CFE4A811FC2A4A648432C6FA2CFD',
      :dbname        => 'magnum',
      :host          => '127.0.0.1',
      :charset       => 'utf8',
      :collate       => 'utf8_general_ci',
    )}
  end

  describe "overriding allowed_hosts param to array" do
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

  describe "overriding allowed_hosts param to string" do
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

  describe "overriding allowed_hosts equal to host param" do
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
