class glusterfs::client {

  require glusterfs::disk

  $ip_glu_1 = hiera('ip_glu_1')
  $mount_point = hiera('mount_point')

  package { 'glusterfs-common': 
    ensure => installed, 
  }
  package { 'glusterfs-client': 
    ensure => installed, 
  }
  package { 'python-software-properties': 
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
    require => [ Package['glusterfs-client'], Package['glusterfs-common'], File["/mnt/${gluster_file}"] ],
  }

}

include glusterfs::client
