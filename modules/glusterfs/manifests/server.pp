class glusterfs::server {
  
  require glusterfs::disk

  class { 'apt':
    always_apt_update => true,
  }

  apt::ppa { 'ppa:semiosis/ubuntu-glusterfs-3.5': }
  ->
  package { ['glusterfs-server','glusterfs-client','glusterfs-common']: 
    ensure => installed, 
  }
  
  service { 'glusterfs stop': 
    name      => 'glusterfs-server',
    ensure    => stopped,
    enable    => true,
    hasstatus => true,
    require   => Package['glusterfs-server','glusterfs-client','glusterfs-common'],
  }
  
  service { 'glusterfs start': 
    name    => 'glusterfs-server',
    ensure  => running,
    require => Service['glusterfs stop'],  
  }
}

include glusterfs::server
