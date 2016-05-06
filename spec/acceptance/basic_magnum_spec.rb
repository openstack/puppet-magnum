require 'spec_helper_acceptance'

describe 'basic magnum' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::rabbitmq
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone

      rabbitmq_vhost { '/magnum':
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }
      rabbitmq_user { 'magnum':
        admin    => true,
        password => 'an_even_bigger_secret',
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }
      rabbitmq_user_permissions { 'magnum@/':
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
        require              => Class['rabbitmq'],
      }

      # Magnum resources
      class { '::magnum::keystone::auth':
        password     => 'a_big_secret',
        public_url   => 'http://127.0.0.1:9511/v1',
        internal_url => 'http://127.0.0.1:9511/v1',
        admin_url    => 'http://127.0.0.1:9511/v1',
      }

      class { '::magnum::db::mysql':
        password => 'magnum',
      }

      class { '::magnum::db':
        database_connection => 'mysql://magnum:magnum@127.0.0.1/magnum',
      }

      class { '::magnum::keystone::domain':
        domain_password => 'oh_my_no_secret',
      }

      class { '::magnum':
        rabbit_host         => '127.0.0.1',
        rabbit_port         => '5672',
        rabbit_userid       => 'magnum',
        rabbit_password     => 'an_even_bigger_secret',
        rabbit_use_ssl      => false,
        notification_driver => 'messagingv2',
       }

       class { '::magnum::api':
        admin_password => 'a_big_secret',
        auth_uri       => 'http://127.0.0.1:5000/',
        identity_uri   => 'http://127.0.0.1:35357/',
        host           => '127.0.0.1',
      }

      class { '::magnum::conductor': }

      class { '::magnum::client': }

      class { '::magnum::certificates':
        cert_manager_type => 'local'
      }
    EOS
      # Run it twice to test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe port(9511) do
      it { is_expected.to be_listening.with('tcp') }
    end

  end
end
