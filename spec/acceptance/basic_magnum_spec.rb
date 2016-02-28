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
        password => 'a_big_secret',
      }
      class { '::magnum::db::mysql':
        password => 'a_big_secret',
      }
      case $::osfamily {
        'Debian': {
          warning('Magnum is not yet packaged on Ubuntu systems.')
        }
        'RedHat': {
          class { '::magnum': }
          class { '::magnum::api':
            admin_password => 'a_big_secret',
          }
          class { '::magnum::conductor': }
        }
      }
      EOS

      # Run it twice to test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    if os[:family].casecmp('RedHat') == 0
      describe port(9511) do
        it { is_expected.to be_listening }
      end
    end

  end
end
