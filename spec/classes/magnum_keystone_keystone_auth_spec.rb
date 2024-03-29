require 'spec_helper'

describe 'magnum::keystone::keystone_auth' do

  let :params do
    { :password => 'magnum_password' }
  end

  shared_examples_for 'magnum::keystone_auth' do

    context 'with default parameters' do
      it 'configure keystone_auth' do
        is_expected.to contain_magnum_config('keystone_auth/username').with_value('magnum')
        is_expected.to contain_magnum_config('keystone_auth/password').with_value('magnum_password')
        is_expected.to contain_magnum_config('keystone_auth/auth_url').with_value('http://localhost:5000')
        is_expected.to contain_magnum_config('keystone_auth/project_name').with_value('services')
        is_expected.to contain_magnum_config('keystone_auth/user_domain_name').with_value('Default')
        is_expected.to contain_magnum_config('keystone_auth/project_domain_name').with_value('Default')
        is_expected.to contain_magnum_config('keystone_auth/system_scope').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('keystone_auth/auth_type').with_value('password')
        is_expected.to contain_magnum_config('keystone_auth/cafile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('keystone_auth/certfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('keystone_auth/keyfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('keystone_auth/insecure').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when overriding parameters' do
      before do
        params.merge!({
          :username            => 'myuser',
          :password            => 'mypasswd',
          :auth_url            => 'http://:127.0.0.1:5000',
          :project_name        => 'service_project',
          :user_domain_name    => 'domainX',
          :project_domain_name => 'domainX',
          :auth_type           => 'v3password',
          :cafile              => '/path/to/ca.cert',
          :certfile            => '/path/to/certfile',
          :keyfile             => '/path/to/key',
          :insecure            => false,
        })
      end

      it 'configure keystone_auth' do
        is_expected.to contain_magnum_config('keystone_auth/username').with_value(params[:username])
        is_expected.to contain_magnum_config('keystone_auth/password').with_value(params[:password])
        is_expected.to contain_magnum_config('keystone_auth/auth_url').with_value(params[:auth_url])
        is_expected.to contain_magnum_config('keystone_auth/project_name').with_value(params[:project_name])
        is_expected.to contain_magnum_config('keystone_auth/user_domain_name').with_value(params[:user_domain_name])
        is_expected.to contain_magnum_config('keystone_auth/project_domain_name').with_value(params[:project_domain_name])
        is_expected.to contain_magnum_config('keystone_auth/system_scope').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('keystone_auth/auth_type').with_value(params[:auth_type])
        is_expected.to contain_magnum_config('keystone_auth/cafile').with_value(params[:cafile])
        is_expected.to contain_magnum_config('keystone_auth/certfile').with_value(params[:certfile])
        is_expected.to contain_magnum_config('keystone_auth/keyfile').with_value(params[:keyfile])
        is_expected.to contain_magnum_config('keystone_auth/insecure').with_value(params[:insecure])
      end
    end

    context 'when system_scope is set' do
      before do
        params.merge!(
          :system_scope => 'all'
        )
      end
      it 'configures system-scoped credential' do
        is_expected.to contain_magnum_config('keystone_auth/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('keystone_auth/project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('keystone_auth/system_scope').with_value('all')
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end
      it_configures 'magnum::keystone_auth'
    end
  end

end
