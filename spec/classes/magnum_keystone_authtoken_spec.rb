require 'spec_helper'

describe 'magnum::keystone::authtoken' do

  let :params do
    { :password => 'magnum_password', }
  end

  shared_examples 'magnum::keystone::authtoken' do

    context 'without required password parameter' do
      before { params.delete(:password) }
      it { expect { is_expected.to raise_error(Puppet::Error) } }
    end

    context 'with default parameters' do
      it { is_expected.to contain_keystone__resource__authtoken('magnum_config').with(
        :username                       => 'magnum',
        :password                       => 'magnum_password',
        :auth_url                       => 'http://localhost:5000',
        :project_name                   => 'services',
        :user_domain_name               => 'Default',
        :project_domain_name            => 'Default',
        :system_scope                   => '<SERVICE DEFAULT>',
        :insecure                       => '<SERVICE DEFAULT>',
        :auth_section                   => '<SERVICE DEFAULT>',
        :auth_type                      => 'password',
        :www_authenticate_uri           => 'http://localhost:5000',
        :auth_version                   => '<SERVICE DEFAULT>',
        :cache                          => '<SERVICE DEFAULT>',
        :cafile                         => '<SERVICE DEFAULT>',
        :certfile                       => '<SERVICE DEFAULT>',
        :delay_auth_decision            => '<SERVICE DEFAULT>',
        :enforce_token_bind             => '<SERVICE DEFAULT>',
        :http_connect_timeout           => '<SERVICE DEFAULT>',
        :http_request_max_retries       => '<SERVICE DEFAULT>',
        :include_service_catalog        => '<SERVICE DEFAULT>',
        :keyfile                        => '<SERVICE DEFAULT>',
        :memcache_pool_conn_get_timeout => '<SERVICE DEFAULT>',
        :memcache_pool_dead_retry       => '<SERVICE DEFAULT>',
        :memcache_pool_maxsize          => '<SERVICE DEFAULT>',
        :memcache_pool_socket_timeout   => '<SERVICE DEFAULT>',
        :memcache_pool_unused_timeout   => '<SERVICE DEFAULT>',
        :memcache_secret_key            => '<SERVICE DEFAULT>',
        :memcache_security_strategy     => '<SERVICE DEFAULT>',
        :memcache_use_advanced_pool     => '<SERVICE DEFAULT>',
        :memcached_servers              => '<SERVICE DEFAULT>',
        :region_name                    => '<SERVICE DEFAULT>',
        :token_cache_time               => '<SERVICE DEFAULT>',
        :service_token_roles            => '<SERVICE DEFAULT>',
        :service_token_roles_required   => '<SERVICE DEFAULT>',
        :service_type                   => '<SERVICE DEFAULT>',
        :interface                      => '<SERVICE DEFAULT>',
      )}

      it {
        is_expected.to contain_magnum_config('keystone_auth/insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('keystone_auth/cafile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('keystone_auth/certfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_magnum_config('keystone_auth/keyfile').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'when overriding parameters' do
      before do
        params.merge!({
          :www_authenticate_uri           => 'https://10.0.0.1:9999/',
          :username                       => 'myuser',
          :password                       => 'mypasswd',
          :auth_url                       => 'http://:127.0.0.1:5000',
          :project_name                   => 'service_project',
          :user_domain_name               => 'domainX',
          :project_domain_name            => 'domainX',
          :system_scope                   => 'all',
          :insecure                       => false,
          :auth_section                   => 'new_section',
          :auth_type                      => 'password',
          :auth_version                   => 'v3',
          :cache                          => 'somevalue',
          :cafile                         => '/opt/stack/data/cafile.pem',
          :certfile                       => 'certfile.crt',
          :delay_auth_decision            => false,
          :enforce_token_bind             => 'permissive',
          :http_connect_timeout           => '300',
          :http_request_max_retries       => '3',
          :include_service_catalog        => true,
          :keyfile                        => 'keyfile',
          :memcache_pool_conn_get_timeout => '9',
          :memcache_pool_dead_retry       => '302',
          :memcache_pool_maxsize          => '11',
          :memcache_pool_socket_timeout   => '2',
          :memcache_pool_unused_timeout   => '61',
          :memcache_secret_key            => 'secret_key',
          :memcache_security_strategy     => 'ENCRYPT',
          :memcache_use_advanced_pool     => true,
          :memcached_servers              => ['memcached01:11211','memcached02:11211'],
          :manage_memcache_package        => true,
          :region_name                    => 'region2',
          :token_cache_time               => '301',
          :service_token_roles            => ['service'],
          :service_token_roles_required   => false,
          :service_type                   => 'identity',
          :interface                      => 'internal',
        })
      end

      it { is_expected.to contain_keystone__resource__authtoken('magnum_config').with(
        :www_authenticate_uri           => params[:www_authenticate_uri],
        :username                       => params[:username],
        :password                       => params[:password],
        :auth_url                       => params[:auth_url],
        :project_name                   => params[:project_name],
        :user_domain_name               => params[:user_domain_name],
        :project_domain_name            => params[:project_domain_name],
        :system_scope                   => params[:system_scope],
        :insecure                       => params[:insecure],
        :auth_section                   => params[:auth_section],
        :auth_type                      => params[:auth_type],
        :auth_version                   => params[:auth_version],
        :cache                          => params[:cache],
        :cafile                         => params[:cafile],
        :certfile                       => params[:certfile],
        :delay_auth_decision            => params[:delay_auth_decision],
        :enforce_token_bind             => params[:enforce_token_bind],
        :http_connect_timeout           => params[:http_connect_timeout],
        :http_request_max_retries       => params[:http_request_max_retries],
        :include_service_catalog        => params[:include_service_catalog],
        :keyfile                        => params[:keyfile],
        :memcache_pool_conn_get_timeout => params[:memcache_pool_conn_get_timeout],
        :memcache_pool_dead_retry       => params[:memcache_pool_dead_retry],
        :memcache_pool_maxsize          => params[:memcache_pool_maxsize],
        :memcache_pool_socket_timeout   => params[:memcache_pool_socket_timeout],
        :memcache_pool_unused_timeout   => params[:memcache_pool_unused_timeout],
        :memcache_secret_key            => params[:memcache_secret_key],
        :memcache_security_strategy     => params[:memcache_security_strategy],
        :memcache_use_advanced_pool     => params[:memcache_use_advanced_pool],
        :memcached_servers              => params[:memcached_servers],
        :region_name                    => params[:region_name],
        :token_cache_time               => params[:token_cache_time],
        :service_token_roles            => params[:service_token_roles],
        :service_token_roles_required   => params[:service_token_roles_required],
        :interface                      => params[:interface],
      )}

      it {
        is_expected.to contain_magnum_config('keystone_auth/insecure').with_value(params[:insecure])
        is_expected.to contain_magnum_config('keystone_auth/cafile').with_value(params[:cafile])
        is_expected.to contain_magnum_config('keystone_auth/certfile').with_value(params[:certfile])
        is_expected.to contain_magnum_config('keystone_auth/keyfile').with_value(params[:keyfile])
      }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'magnum::keystone::authtoken'
    end
  end

end
