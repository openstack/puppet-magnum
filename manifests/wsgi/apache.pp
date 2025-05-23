#
# Copyright (C) 2018 Binero
#
# Author: Tobias Urdin <tobias.urdin@binero.se>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: magnum::wsgi::apache
#
# Install Magnum API under apache with mod_wsgi.
#
# == Parameters:
#
# [*servername*]
#   (Optional) The servername for the virtualhost.
#   Defaults to $facts['networking']['fqdn']
#
# [*port*]
#   (Optional) The port.
#   Defaults to 9511
#
# [*bind_host*]
#   (Optional) The host/ip address Apache will listen on.
#   Defaults to undef (listen on all ip addresses).
#
# [*path*]
#   (Optional) The prefix for the endpoint.
#   Defaults to '/'
#
# [*ssl*]
#   (Optional) Use ssl.
#   Defaults to false
#
# [*workers*]
#   (Optional) Number of WSGI workers to spawn.
#   Defaults to $facts['os_workers']
#
# [*priority*]
#   (Optional) The priority for the vhost.
#   Defaults to 10
#
# [*threads*]
#   (Optional) The number of threads for the vhost.
#   Defaults to 1
#
# [*wsgi_process_display_name*]
#   (Optional) Name of the WSGI process display-name.
#   Defaults to undef
#
# [*ssl_cert*]
# [*ssl_key*]
# [*ssl_chain*]
# [*ssl_ca*]
# [*ssl_crl_path*]
# [*ssl_crl*]
# [*ssl_certs_dir*]
#   (Optional) apache::vhost ssl parameters.
#   Default to apache::vhost 'ssl_*' defaults
#
# [*access_log_file*]
#   (Optional) The log file name for the virtualhost.
#   Defaults to undef.
#
# [*access_log_pipe*]
#   (Optional) Specifies a pipe where Apache sends access logs for
#   the virtualhost.
#   Defaults to undef.
#
# [*access_log_syslog*]
#   (Optional) Sends the virtualhost access log messages to syslog.
#   Defaults to undef.
#
# [*access_log_format*]
#   (Optional) The log format for the virtualhost.
#   Defaults to undef.
#
# [*error_log_file*]
#   (Optional) The error log file name for the virtualhost.
#   Defaults to undef.
#
# [*error_log_pipe*]
#   (Optional) Specifies a pipe where Apache sends error logs for
#   the virtualhost.
#   Defaults to undef.
#
# [*error_log_syslog*]
#   (Optional) Sends the virtualhost error log messages to syslog.
#   Defaults to undef.
#
# [*custom_wsgi_process_options*]
#   (Optional) gives you the opportunity to add custom process options or to
#   overwrite the default options for the WSGI main process.
#   eg. to use a virtual python environment for the WSGI process
#   you could set it to:
#   { python-path => '/my/python/virtualenv' }
#   Defaults to {}
#
# [*headers*]
#   (Optional) Headers for the vhost.
#   Defaults to undef
#
# [*request_headers*]
#   (Optional) Modifies collected request headers in various ways.
#   Defaults to undef
#
# == Example:
#
#   include apache
#   class { 'magnum::wsgi::apache': }
#
class magnum::wsgi::apache (
  $servername                  = $facts['networking']['fqdn'],
  $port                        = 9511,
  $bind_host                   = undef,
  $path                        = '/',
  $ssl                         = false,
  $workers                     = $facts['os_workers'],
  $ssl_cert                    = undef,
  $ssl_key                     = undef,
  $ssl_chain                   = undef,
  $ssl_ca                      = undef,
  $ssl_crl_path                = undef,
  $ssl_crl                     = undef,
  $ssl_certs_dir               = undef,
  $wsgi_process_display_name   = undef,
  $threads                     = 1,
  $priority                    = 10,
  $access_log_file             = undef,
  $access_log_pipe             = undef,
  $access_log_syslog           = undef,
  $access_log_format           = undef,
  $error_log_file              = undef,
  $error_log_pipe              = undef,
  $error_log_syslog            = undef,
  $custom_wsgi_process_options = {},
  $headers                     = undef,
  $request_headers             = undef,
) {

  include magnum::deps
  include magnum::params

  Anchor['magnum::install::end'] -> Class['apache']

  openstacklib::wsgi::apache { 'magnum_wsgi':
    bind_host                   => $bind_host,
    bind_port                   => $port,
    group                       => $::magnum::params::group,
    path                        => $path,
    priority                    => $priority,
    servername                  => $servername,
    ssl                         => $ssl,
    ssl_ca                      => $ssl_ca,
    ssl_cert                    => $ssl_cert,
    ssl_certs_dir               => $ssl_certs_dir,
    ssl_chain                   => $ssl_chain,
    ssl_crl                     => $ssl_crl,
    ssl_crl_path                => $ssl_crl_path,
    ssl_key                     => $ssl_key,
    threads                     => $threads,
    user                        => $::magnum::params::user,
    workers                     => $workers,
    wsgi_daemon_process         => 'magnum',
    wsgi_process_display_name   => $wsgi_process_display_name,
    wsgi_process_group          => 'magnum',
    wsgi_script_dir             => $::magnum::params::wsgi_script_path,
    wsgi_script_file            => 'app',
    wsgi_script_source          => $::magnum::params::wsgi_script_source,
    headers                     => $headers,
    request_headers             => $request_headers,
    custom_wsgi_process_options => $custom_wsgi_process_options,
    access_log_file             => $access_log_file,
    access_log_pipe             => $access_log_pipe,
    access_log_syslog           => $access_log_syslog,
    access_log_format           => $access_log_format,
    error_log_file              => $error_log_file,
    error_log_pipe              => $error_log_pipe,
    error_log_syslog            => $error_log_syslog,
  }
}
