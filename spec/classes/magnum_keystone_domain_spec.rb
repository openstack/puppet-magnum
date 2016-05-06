require 'spec_helper'

describe 'magnum::keystone::domain' do

  let :params do {
    :domain_name        => 'magnum',
    :domain_admin       => 'magnum_admin',
    :domain_admin_email => 'magnum_admin@localhost',
    :domain_password    => 'domain_passwd'
    }
  end

  shared_examples_for 'magnum keystone domain' do
    it 'configure magnum.conf' do
      #is_expected.to contain_magnum_config('trust/trustee_domain_admin_id').with_value(params[:domain_admin])
      is_expected.to contain_magnum_config('trust/trustee_domain_admin_password').with_value(params[:domain_password])
      is_expected.to contain_magnum_config('trust/trustee_domain_admin_password').with_secret(true)
      #is_expected.to contain_magnum_config('trust/trustee_domain_id').with_value(params[:domain_name])
    end

    it 'should create keystone domain' do
      is_expected.to contain_keystone_domain(params[:domain_name]).with(
        :ensure  => 'present',
        :enabled => 'true',
        :name    => params[:domain_name]
      )

      is_expected.to contain_keystone_user("#{params[:domain_admin]}::#{params[:domain_name]}").with(
        :ensure   => 'present',
        :enabled  => 'true',
        :email    => params[:domain_admin_email],
        :password => params[:domain_password],
      )
      is_expected.to contain_keystone_user_role("#{params[:domain_admin]}::#{params[:domain_name]}@::#{params[:domain_name]}").with(
        :roles => ['admin'],
      )
    end

    context 'when not managing the domain creation' do
      before do
        params.merge!(
          :manage_domain => false
        )
      end

      it { is_expected.to_not contain_keystone_domain('magnum_domain') }
    end

    context 'when not managing the user creation' do
      before do
        params.merge!(
          :manage_user => false
        )
      end

      it { is_expected.to_not contain_keystone_user("#{params[:domain_admin]}::#{params[:domain_name]}") }
    end

    context 'when not managing the user role creation' do
      before do
        params.merge!(
          :manage_role => false
        )
      end

      it { is_expected.to_not contain_keystone_user_role("#{params[:domain_admin]}::#{params[:domain_name]}@::#{params[:domain_name]}") }
    end
  end


  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

    it_configures 'magnum keystone domain'
    end
  end
end
