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
  exec { 'disabling firewall':
    command => 'ufw disable',
    path    => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin",
    require => Service['glusterfs-server'],
  }
  exec { 'network reload':
    command => 'networking force-reload',
    path    => "/etc/init.d/",
    require => Exec['disabling firewall'],
  }
}

include glusterfs::server
