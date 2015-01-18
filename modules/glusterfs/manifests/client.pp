class glusterfs::client {

  $ip_glu_1 = hiera('ip_glu_1')
  $mount_point = hiera('mount_point')

  class { 'apt':
    always_apt_update => true,
  }
  
  apt::ppa { 'ppa:semiosis/ubuntu-glusterfs-3.5': }
  ->
  package { ['glusterfs-client','glusterfs-common']: 
    ensure => installed, 
  }

  file { "/mnt/${gluster_file}": 
    ensure => directory, 
  } 
  
  # DISABLING FIREWALL
  exec { 'sudo ufw disable':
    require => Service['glusterfs-server'],
  }
  
  mount { "/mnt/${gluster_file}":
    ensure  => 'mounted',
    options => 'defaults',
    fstype  => 'glusterfs',
    device  => "${ip_glu_1}:/${gluster_file}",
    require => [ Exec['sudo ufw disable'], Package['glusterfs-client','glusterfs-common'] ],
  }

}

include glusterfs::client
