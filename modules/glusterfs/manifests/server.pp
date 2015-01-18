class glusterfs::server {
  
  require glusterfs::disk
  require glusterfs::key
  
  class { 'apt':
    always_apt_update => true,
  }

  #apt::ppa { 'ppa:semiosis/ubuntu-glusterfs-3.5': }
  #->
  package { ['glusterfs-server','glusterfs-client','glusterfs-common']: 
    ensure => installed, 
  }
  
  service { 'glusterfs-server': 
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    path       => '/etc/init.d',
    require    => Package['glusterfs-server','glusterfs-client','glusterfs-common'],
  }
  
  # DISABLING FIREWALL
  exec { 'sudo ufw disable':
    require => Service['glusterfs-server'],
  }

}

include glusterfs::server
