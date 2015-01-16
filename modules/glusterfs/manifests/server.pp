class glusterfs::server {

  require glusterfs::disk

  $ip_glu_1 = hiera('ip_glu_1')
  $ip_glu_2 = hiera('ip_glu_2')
  $ip_glu_3 = hiera('ip_glu_3')
  $ip_glu_4 = hiera('ip_glu_4')
  $ip_glu_5 = hiera('ip_glu_5')
  $mount_point = hiera('mount_point')
  $gluster_file = hiera('gluster_file')  
  $gluster_nodes = hiera('gluster_nodes')

  case $gluster_nodes {
    '2': {
      $peer_probe = "gluster peer probe ${ip_glu_2}"
    }
    '3': {
      $peer_probe = "gluster peer probe ${ip_glu_2} && gluster peer probe ${ip_glu_3}"  
    }
    '4': {
      $peer_probe = "gluster peer probe ${ip_glu_2} && gluster peer probe ${ip_glu_3} && gluster peer probe ${ip_glu_4}"  
    }
    '5': {
      $peer_probe = "gluster peer probe ${ip_glu_2} && gluster peer probe ${ip_glu_3} && gluster peer probe ${ip_glu_4} && gluster peer probe ${ip_glu_5}"  
    }
  }

  $vol_create_opt = "replica 3 transport tcp ${ip_glu_1}:${mount_point} ${ip_glu_2}:${mount_point} ${ip_glu_3}:${mount_point} force" 

  package { 'glusterfs-server': 
    ensure => installed, 
  }

  service { 'glusterfs-server': 
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package['glusterfs-server'],
  }

  exec { "gluster peer probe":
    command => $peer_probe,
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",  
    require => Service["glusterfs-server"],
  }

  exec { "gluster volume create":
    command => "gluster volume create ${gluster_file} ${vol_create_opt}",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",  
    require => Exec["gluster peer probe"],
  }   
  
  exec { "gluster volume start":
    command => "gluster volume start ${gluster_file}",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",  
    require => Exec["gluster volume create"],
  }
    
}

include glusterfs::server
