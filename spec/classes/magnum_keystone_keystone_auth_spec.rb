require 'spec_helper'

describe 'magnum::keystone::keystone_auth' do

  let :params do
    { }
  end

  shared_examples_for 'magnum keystone_auth' do

    context 'with default parameters' do
      it 'configure keystone_auth' do
        is_expected.not_to contain_magnum_config('keystone_auth/username')
      end
    end

    context 'with password' do
      before do
        params.merge!({
          :password => 'magnum_password',
        })
      end

      it 'configure keystone_auth' do
        is_expected.to contain_magnum_config('keystone_auth/username').with_value('magnum')
        is_expected.to contain_magnum_config('keystone_auth/password').with_value('magnum_password')
        is_expected.to contain_magnum_config('keystone_auth/auth_url').with_value('http://localhost:5000')
        is_expected.to contain_magnum_config('keystone_auth/project_name').with_value('services')
        is_expected.to contain_magnum_config('keystone_auth/user_domain_name').with_value('Default')
        is_expected.to contain_magnum_config('keystone_auth/project_domain_name').with_value('Default')
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
        })
      end

      it 'configure keystone_auth' do
        is_expected.to contain_magnum_config('keystone_auth/username').with_value(params[:username])
        is_expected.to contain_magnum_config('keystone_auth/password').with_value(params[:password])
        is_expected.to contain_magnum_config('keystone_auth/auth_url').with_value(params[:auth_url])
        is_expected.to contain_magnum_config('keystone_auth/project_name').with_value(params[:project_name])
        is_expected.to contain_magnum_config('keystone_auth/user_domain_name').with_value(params[:user_domain_name])
        is_expected.to contain_magnum_config('keystone_auth/project_domain_name').with_value(params[:project_domain_name])
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
      it_configures 'magnum keystone_auth'
    end
  end

end
