class gluster::server {

  require gluster::disk

  $ip_glu_1 = hiera('ip_glu_1')
  $ip_glu_2 = hiera('ip_glu_2')
  $ip_glu_3 = hiera('ip_glu_3')
  $hst_glu_1 = hiera('hst_glu_1')
  $hst_glu_2 = hiera('hst_glu_2')
  $hst_glu_3 = hiera('hst_glu_3')
  $mount_point = hiera('mount_point')

  class { 'glusterfs::server':
    peers => $::hostname ? {
      $hst_glu_1 => $ip_glu_1, 
      $hst_glu_2 => $ip_glu_2, 
      $hst_glu_3 => $ip_glu_3,
    },
  }

  glusterfs::volume { 'gfile':
    create_options => "replica 3 transport tcp ${ip_glu_1}:${mount_point} ${ip_glu_2}:${mount_point} ${ip_glu_3}:${mount_point} force" 
  }

}

include gluster::server
