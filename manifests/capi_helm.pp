# == Class: magnum::capi_helm
#
# Manages the magnum capi_helm section
#
# Warning: the capi_helm functionality needs installation of
#          additional components which are not yet available as
#          packages. This class adds the possibility to configure
#          the magnum config part only.
#
# === Parameters:
# [*kubeconfig_file*]
#   (optional) Path to a kubeconfig file for a management cluster,
#   for use in the Cluster API driver.
#   Defaults to $facts['os_service_default']
#
# [*kubeconfig*]
#   if defined and $kubeconfig_file is set, the file is
#   written with this content.
#   Defaults to undef
#
# [*kubeconfig_owner*]
#   owner of kubeconfig_file
#   Defaults to magnum
#
# [*kubeconfig_group*]
#   owner of kubeconfig_file
#   Defaults to magnum
#
# [*kubeconfig_mode*]
#   mode of kubeconfig_file
#   Defaults to '0400'
#
# [*namespace_prefix*]
#   (optional) Resources for each openstack cluster are created in a
#   separate namespace within the CAPI Management cluster
#   specified by the configuration: [capi_helm]/kubeconfig_file
#   You should modify this prefix when two magnum deployments
#   want to share a single CAPI management cluster.
#   Defaults to $facts['os_service_default']
#
# [*helm_chart_repo*]
#   (optional) Reference to the helm chart repository for
#   the cluster API driver.
#   Note that if helm_chart_name starts with oci://
#   you will want this to set this to the empty string.
#   Defaults to $facts['os_service_default']
#
# [*helm_chart_name*]
#   (optional) Name of the helm chart to use from the repo specified
#   by the config: capi_driver.helm_chart_repo
#   Defaults to $facts['os_service_default']
#
# [*default_helm_chart_version*]
#   (optional) Version of the helm chart specified
#   by the config: capi_driver.helm_chart_repo
#   and capi_driver.helm_chart_name.
#   Defaults to $facts['os_service_default']
#
# [*minimum_flavor_ram*]
#   (optional) Minimum RAM for flavor used to
#   create a Kubernetes node.
#   Defaults to $facts['os_service_default']
#
# [*minimum_flavor_vcpus*]
#   (optional) Minimum VCPUS for flavor used to
#   create a Kubernetes node.
#   Defaults to $facts['os_service_default']
#
# [*csi_cinder_default_volume_type*]
#   (optional) StorageClass volume type for persistent volumes
#
# [*csi_cinder_reclaim_policy*]
#   (optional) Policy for reclaiming dynamically created
#   persistent volumes. Can be 'Retain' or 'Delete'.
#   Defaults to $facts['os_service_default']
#
# [*csi_cinder_allow_volume_expansion*]
#   (optional) Allows the users to resize the volume by
#   editing the corresponding PVC object.
#   Defaults to $facts['os_service_default']
#
# [*csi_cinder_allowed_topologies*]
#   (optional) Allows the users to resize the volume by
#   editing the corresponding PVC object.
#   Defaults to $facts['os_service_default']
#
# [*csi_cinder_fstype*]
#   (optional) Filesystem type for persistent volumes.
#   Defaults to $facts['os_service_default']
#
# [*csi_cinder_volume_binding_mode*]
#   (optional) The volumeBindingMode field controls when
#   volume binding and dynamic provisioning should occur.
#   Defaults to $facts['os_service_default']
#
# [*csi_cinder_availability_zone*]
#   (optional) The default availability zone to use for Cinder volumes.
#   Defaults to $facts['os_service_default']
#
# [*app_cred_interface_type*]
#   (optional) The value to use in the interface field of
#   generated application credentials.
#   Defaults to $facts['os_service_default']
#
class magnum::capi_helm (
  Optional[Stdlib::Absolutepath] $kubeconfig_file                                  = undef,
  Optional[Hash] $kubeconfig                                                       = undef,
  String[1] $kubeconfig_owner                                                      = $magnum::params::user,
  String[1] $kubeconfig_group                                                      = $magnum::params::group,
  Stdlib::Filemode $kubeconfig_mode                                                = '0400',
  String[1] $namespace_prefix                                                      = $facts['os_service_default'],
  String[1] $helm_chart_repo                                                       = $facts['os_service_default'],
  String[1] $helm_chart_name                                                       = $facts['os_service_default'],
  String[1] $default_helm_chart_version                                            = $facts['os_service_default'],
  Variant[Integer, Openstacklib::ServiceDefault] $minimum_flavor_ram               = $facts['os_service_default'],
  Variant[Integer, Openstacklib::ServiceDefault] $minimum_flavor_vcpus             = $facts['os_service_default'],
  String[1] $csi_cinder_default_volume_type                                        = $facts['os_service_default'],
  String[1] $csi_cinder_reclaim_policy                                             = $facts['os_service_default'],
  Variant[Boolean,Openstacklib::ServiceDefault] $csi_cinder_allow_volume_expansion = $facts['os_service_default'],
  Variant[Array,Openstacklib::ServiceDefault] $csi_cinder_allowed_topologies       = $facts['os_service_default'],
  String[1] $csi_cinder_fstype                                                     = $facts['os_service_default'],
  String[1] $csi_cinder_volume_binding_mode                                        = $facts['os_service_default'],
  String[1] $csi_cinder_availability_zone                                          = $facts['os_service_default'],
  String[1] $app_cred_interface_type                                               = $facts['os_service_default'],
) inherits magnum::params {

  include magnum::deps

  magnum_config {
    'capi_helm/kubeconfig_file':                   value => pick($kubeconfig_file,$facts['os_service_default']);
    'capi_helm/namespace_prefix':                  value => $namespace_prefix;
    'capi_helm/helm_chart_repo':                   value => $helm_chart_repo;
    'capi_helm/helm_chart_name':                   value => $helm_chart_name;
    'capi_helm/default_helm_chart_version':        value => $default_helm_chart_version;
    'capi_helm/minimum_flavor_ram':                value => $minimum_flavor_ram;
    'capi_helm/minimum_flavor_vcpus':              value => $minimum_flavor_vcpus;
    'capi_helm/csi_cinder_default_volume_type':    value => $csi_cinder_default_volume_type;
    'capi_helm/csi_cinder_reclaim_policy':         value => $csi_cinder_reclaim_policy;
    'capi_helm/csi_cinder_allow_volume_expansion': value => $csi_cinder_allow_volume_expansion;
    'capi_helm/csi_cinder_allowed_topologies':     value => join(any2array($csi_cinder_allowed_topologies) ,',');
    'capi_helm/csi_cinder_fstype':                 value => $csi_cinder_fstype;
    'capi_helm/csi_cinder_volume_binding_mode':    value => $csi_cinder_volume_binding_mode;
    'capi_helm/csi_cinder_availability_zone':      value => $csi_cinder_availability_zone;
    'capi_helm/app_cred_interface_type':           value => $app_cred_interface_type;
  }

  if $kubeconfig_file and $kubeconfig {
    file{ $kubeconfig_file:
      owner   => $kubeconfig_owner,
      group   => $kubeconfig_group,
      mode    => $kubeconfig_mode,
      content => stdlib::to_yaml($kubeconfig),
      require => Anchor['magnum::config::begin'],
      before  => Anchor['magnum::config::end'],
    }
  }
}

