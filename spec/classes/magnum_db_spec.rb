require 'spec_helper'

describe 'magnum::db' do

  shared_examples 'magnum::db' do
    context 'with default parameters' do
      it { is_expected.to contain_oslo__db('magnum_config').with(
        :db_max_retries => '<SERVICE DEFAULT>',
        :connection     => 'mysql+pymysql://magnum:magnum@localhost:3306/magnum',
        :idle_timeout   => '<SERVICE DEFAULT>',
        :min_pool_size  => '<SERVICE DEFAULT>',
        :max_pool_size  => '<SERVICE DEFAULT>',
        :max_retries    => '<SERVICE DEFAULT>',
        :retry_interval => '<SERVICE DEFAULT>',
        :max_overflow   => '<SERVICE DEFAULT>',
      )}
    end

    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mysql+pymysql://magnum:magnum@localhost/magnum',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_retries    => '11',
          :database_retry_interval => '11',
          :database_max_pool_size  => '11',
          :database_max_overflow   => '21',
          :database_db_max_retries => '-1',
        }
      end

      it { is_expected.to contain_oslo__db('magnum_config').with(
        :db_max_retries => '-1',
        :connection     => 'mysql+pymysql://magnum:magnum@localhost/magnum',
        :idle_timeout   => '3601',
        :min_pool_size  => '2',
        :max_pool_size  => '11',
        :max_retries    => '11',
        :retry_interval => '11',
        :max_overflow   => '21',
      )}
    end

    context 'with postgresql backend' do
      let :params do
        { :database_connection => 'postgresql://magnum:magnum@localhost/magnum', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end

    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection => 'invalid://magnum:magnum@localhost/magnum', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'magnum::db'
    end
  end
end
