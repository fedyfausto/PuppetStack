class glusterfs::mainserver {
  
  require glusterfs::disk
  require glusterfs::key
  
  $mount_point = hiera('mount_point')
  $gluster_file = hiera('gluster_file')  
  $gluster_nodes = hiera('gluster_nodes')
  $brick = "${mount_point}/brick/"

  case $gluster_nodes {
    '2': {
      $ip_glu_1 = hiera('ip_glu_1')
      $ip_glu_2 = hiera('ip_glu_2')
      $peer_probe = "gluster peer probe ${ip_glu_2}"
      $vol_create_opt = "replica 3 transport tcp ${ip_glu_1}:${brick} ${ip_glu_2}:${brick} force" 
    }
    '3': {
      $ip_glu_1 = hiera('ip_glu_1')
      $ip_glu_2 = hiera('ip_glu_2')
      $ip_glu_3 = hiera('ip_glu_3')
      $peer_probe = "gluster peer probe ${ip_glu_2} && gluster peer probe ${ip_glu_3}"
      $vol_create_opt = "replica 3 transport tcp ${ip_glu_1}:${brick} ${ip_glu_2}:${brick} ${ip_glu_3}:${brick} force" 
    }
    '4': {
      $ip_glu_1 = hiera('ip_glu_1')
      $ip_glu_2 = hiera('ip_glu_2')
      $ip_glu_3 = hiera('ip_glu_3')
      $ip_glu_4 = hiera('ip_glu_4')
      $peer_probe = "gluster peer probe ${ip_glu_2} && gluster peer probe ${ip_glu_3} && gluster peer probe ${ip_glu_4}"  
      $vol_create_opt = "replica 3 transport tcp ${ip_glu_1}:${brick} ${ip_glu_2}:${brick} ${ip_glu_3}:${brick} ${ip_glu_4}:${brick} force" 
    }
    '5': {
      $ip_glu_1 = hiera('ip_glu_1')
      $ip_glu_2 = hiera('ip_glu_2')
      $ip_glu_3 = hiera('ip_glu_3')
      $ip_glu_4 = hiera('ip_glu_4')
      $ip_glu_5 = hiera('ip_glu_5')
      $peer_probe = "gluster peer probe ${ip_glu_2} && gluster peer probe ${ip_glu_3} && gluster peer probe ${ip_glu_4} && gluster peer probe ${ip_glu_5}"  
      $vol_create_opt = "replica 3 transport tcp ${ip_glu_1}:${brick} ${ip_glu_2}:${brick} ${ip_glu_3}:${brick} ${ip_glu_4}:${brick} ${ip_glu_5}:${brick} force" 
    }
  }
  
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

  exec { "gluster peer probe":
    command => $peer_probe,
    path    => "/usr/sbin/",  
    require => Exec['sudo ufw disable'],
  }

  exec { "gluster volume create":
    command => "gluster volume create ${gluster_file} ${vol_create_opt}",
    path    => "/usr/sbin/",  
    require => Exec["gluster peer probe"],
  }   
  
  exec { "gluster volume start":
    command => "gluster volume start ${gluster_file}",
    unless  => "[ \"`gluster volume info ${gluster_file} | egrep '^Status:'`\" = 'Status: Started' ]",
    path    => [ '/usr/sbin', '/usr/bin', '/sbin', '/bin' ],  
    require => Exec["gluster volume create"],
  }
    
}

include glusterfs::mainserver
