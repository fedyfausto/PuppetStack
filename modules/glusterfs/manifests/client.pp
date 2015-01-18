class glusterfs::client {
  
  require glusterfs::key
  
  $ip_glu_1 = hiera('ip_glu_1')
  $mount_point = hiera('mount_point')

  class { 'apt':
    always_apt_update => true,
  }
  
  #apt::ppa { 'ppa:semiosis/ubuntu-glusterfs-3.5': }
  #->
  package { ['glusterfs-client','glusterfs-common']: 
    ensure => installed, 
  }

  file { "/mnt/${gluster_file}": 
    ensure => directory, 
  } 
  
  # DISABLING FIREWALL
  exec { 'sudo ufw disable':
    require => Package['glusterfs-client','glusterfs-common'],
  }
  
  mount { "/mnt/${gluster_file}":
    ensure  => 'mounted',
    options => 'defaults',
    fstype  => 'glusterfs',
    device  => "${ip_glu_1}:/${gluster_file}",
    require => [ File["/mnt/${gluster_file}"], Exec['sudo ufw disable'] ],
  }

}

include glusterfs::client
