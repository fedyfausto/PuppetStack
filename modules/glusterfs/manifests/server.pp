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
  
  service { 'glusterfs service': 
    name      => 'glusterfs-server',
    ensure    => running,
    enable    => true,
    hasstatus => true,
    restart   => true,
    require   => Package['glusterfs-server','glusterfs-client','glusterfs-common'],
  }
  
  service { 'dns-clean':
    restart => true,
    require => Service['glusterfs service'],
  }
  
  exec { 'networking reload':
    command => 'sudo service networking force-reload',
    path    => '/etc/init.d/',
    require => Service['dns-clean'],
  }

  
}

include glusterfs::server
