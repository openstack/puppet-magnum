require 'spec_helper'

describe 'magnum::db' do

  shared_examples 'magnum::db' do
    context 'with default parameters' do
      it { is_expected.to contain_magnum_config('database/connection').with_value('mysql://magnum:magnum@localhost:3306/magnum') }
      it { is_expected.to contain_magnum_config('database/idle_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('database/min_pool_size').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('database/max_retries').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('database/retry_interval').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('database/max_pool_size').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('database/max_overflow').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('database/db_max_retries').with_value('<SERVICE DEFAULT>') }
    end

    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mysql://magnum:magnum@localhost/magnum',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_retries    => '11',
          :database_retry_interval => '11',
          :database_max_pool_size  => '11',
          :database_max_overflow   => '21',
          :database_db_max_retries => '-1',
        }
      end

      it { is_expected.to contain_magnum_config('database/connection').with_value('mysql://magnum:magnum@localhost/magnum') }
      it { is_expected.to contain_magnum_config('database/idle_timeout').with_value('3601') }
      it { is_expected.to contain_magnum_config('database/min_pool_size').with_value('2') }
      it { is_expected.to contain_magnum_config('database/max_retries').with_value('11') }
      it { is_expected.to contain_magnum_config('database/retry_interval').with_value('11') }
      it { is_expected.to contain_magnum_config('database/max_pool_size').with_value('11') }
      it { is_expected.to contain_magnum_config('database/max_overflow').with_value('21') }
      it { is_expected.to contain_magnum_config('database/db_max_retries').with_value('-1') }
    end

    context 'with postgresql backend' do
      let :params do
        { :database_connection     => 'postgresql://magnum:magnum@localhost/magnum', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end

    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection     => 'sqlite://magnum:magnum@localhost/magnum', }
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
