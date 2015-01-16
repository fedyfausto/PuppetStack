class gluster::client {

  require gluster::disk

  $ip_glu_1 = hiera('ip_glu_1')
  $ip_glu_2 = hiera('ip_glu_2')
  $ip_glu_3 = hiera('ip_glu_3')
  $mount_point = hiera('mount_point')

  file { '/mnt/gfile': ensure => directory } 
  
  glusterfs::mount { '/mnt/gfile':
    device => $::hostname ? {
      'client1' => "${ip_glu_1}:/gfile",
      'client2' => "${ip_glu_2}:/gfile",
      'client3' => "${ip_glu_3}:/gfile",
    }
  }

}

include gluster::client
