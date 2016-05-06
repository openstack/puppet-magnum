# An example compatible with https://github.com/openstack/puppet-openstack-integration approach
# Works on Mitaka release
# Tested on RDO/CentOS 7 and Puppet 3.8.7
#

  include ::openstack_integration::config
  include ::openstack_integration::params

  rabbitmq_user { 'magnum':
    admin    => true,
    password => 'an_even_bigger_secret',
    provider => 'rabbitmqctl',
    require  => Class['::rabbitmq'],
  }

  rabbitmq_user_permissions { 'magnum@/':
    configure_permission => '.*',
    write_permission     => '.*',
    read_permission      => '.*',
    provider             => 'rabbitmqctl',
    require              => Class['::rabbitmq'],
  }

  class { '::magnum::db::mysql':
    password => 'magnum',
  }

  class { '::magnum::db':
    database_connection => 'mysql://magnum:magnum@127.0.0.1/magnum',
  }

  class { '::magnum::api':
    admin_password => 'a_big_secret',
    auth_uri       => $::openstack_integration::config::keystone_auth_uri,
    identity_uri   => $::openstack_integration::config::keystone_admin_uri,
    host           => $::openstack_integration::config::ip_for_url,
    auth_version   => 'v3',
  }

  class { '::magnum::keystone::auth':
    password     => 'a_big_secret',
    public_url   => "http://${::openstack_integration::config::ip_for_url}:9511/v1",
    internal_url => "http://${::openstack_integration::config::ip_for_url}:9511/v1",
    admin_url    => "http://${::openstack_integration::config::ip_for_url}:9511/v1",
  }

  class { '::magnum':
    rabbit_host         => $::openstack_integration::config::ip_for_url,
    rabbit_port         => $::openstack_integration::config::rabbit_port,
    rabbit_userid       => 'magnum',
    rabbit_password     => 'an_even_bigger_secret',
    rabbit_use_ssl      => $::openstack_integration::config::ssl,
    notification_driver => 'messagingv2',
  }

  class { '::magnum::conductor':
  }

  class { '::magnum::client':
  }
