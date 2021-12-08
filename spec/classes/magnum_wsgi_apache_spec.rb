require 'spec_helper'

describe 'magnum::wsgi::apache' do

  shared_examples_for 'apache serving magnum with mod_wsgi' do
    context 'with default parameters' do
      it { is_expected.to contain_class('magnum::params') }
      it { is_expected.to contain_openstacklib__wsgi__apache('magnum_wsgi').with(
        :bind_port                   => 9511,
        :group                       => 'magnum',
        :path                        => '/',
        :servername                  => facts[:fqdn],
        :ssl                         => false,
        :threads                     => 1,
        :user                        => 'magnum',
        :workers                     => facts[:os_workers],
        :wsgi_daemon_process         => 'magnum',
        :wsgi_process_group          => 'magnum',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'app',
        :wsgi_script_source          => platform_params[:wsgi_script_source],
        :custom_wsgi_process_options => {},
        :access_log_file             => false,
        :access_log_format           => false,
      )}
    end

    context 'when overriding parameters using different ports' do
      let :params do
        {
          :servername                  => 'dummy.host',
          :bind_host                   => '10.42.51.1',
          :port                        => 12345,
          :ssl                         => true,
          :wsgi_process_display_name   => 'magnum',
          :workers                     => 37,
          :custom_wsgi_process_options => {
            'python_path' => '/my/python/path',
          },
          :access_log_file             => '/var/log/httpd/access_log',
          :access_log_format           => 'some format',
          :error_log_file              => '/var/log/httpd/error_log',
        }
      end
      it { is_expected.to contain_class('magnum::params') }
      it { is_expected.to contain_openstacklib__wsgi__apache('magnum_wsgi').with(
        :bind_host                 => '10.42.51.1',
        :bind_port                 => 12345,
        :group                     => 'magnum',
        :path                      => '/',
        :servername                => 'dummy.host',
        :ssl                       => true,
        :threads                   => 1,
        :user                      => 'magnum',
        :workers                   => 37,
        :wsgi_daemon_process       => 'magnum',
        :wsgi_process_display_name => 'magnum',
        :wsgi_process_group        => 'magnum',
        :wsgi_script_dir           => platform_params[:wsgi_script_path],
        :wsgi_script_file          => 'app',
        :wsgi_script_source        => platform_params[:wsgi_script_source],
        :custom_wsgi_process_options => {
          'python_path' => '/my/python/path',
        },
        :access_log_file           => '/var/log/httpd/access_log',
        :access_log_format         => 'some format',
        :error_log_file            => '/var/log/httpd/error_log'
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld'
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          {
            :wsgi_script_path   => '/usr/lib/cgi-bin/magnum',
            :wsgi_script_source => '/usr/lib/python3/dist-packages/magnum/api/app.wsgi'
          }
        when 'RedHat'
          {
            :wsgi_script_path   => '/var/www/cgi-bin/magnum',
            :wsgi_script_source => '/usr/bin/magnum-api-wsgi'
          }

        end
      end
      it_configures 'apache serving magnum with mod_wsgi'
    end
  end

end
