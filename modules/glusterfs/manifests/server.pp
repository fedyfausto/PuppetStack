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
    ensure    => running,
    enable    => true,
    hasstatus => true,
    restart   => true,
    require   => Package['glusterfs-server','glusterfs-client','glusterfs-common'],
  }
  
  
}

include glusterfs::server
