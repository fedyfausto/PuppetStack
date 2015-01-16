class glusterfs::client {

  require glusterfs::disk

  $ip_glu_1 = hiera('ip_glu_1')
  $mount_point = hiera('mount_point')

  package { 'glusterfs-fuse': 
    ensure => installed, 
  }

  file { "/mnt/${gluster_file}": 
    ensure => directory, 
  } 
  
  mount { "/mnt/${gluster_file}":
    ensure  => 'mounted',
    options => 'defaults',
    fstype  => 'glusterfs',
    device  => "${ip_glu_1}:/${gluster_file}",
    require => [ Package['glusterfs-fuse'], File["/mnt/${gluster_file}"] ],
  }

}

include glusterfs::client
