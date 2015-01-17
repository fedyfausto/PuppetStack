class glusterfs::mainserver {
  
  require glusterfs::disk

  $ip_glu_1 = hiera('ip_glu_1')
  $ip_glu_2 = hiera('ip_glu_2')
  $ip_glu_3 = hiera('ip_glu_3')
  $ip_glu_4 = hiera('ip_glu_4')
  $ip_glu_5 = hiera('ip_glu_5')
  
  $mount_point = hiera('mount_point')
  $gluster_file = hiera('gluster_file')  
  $gluster_nodes = hiera('gluster_nodes')
  $brick = "${mount_point}/brick/"

  class { 'apt':
    always_apt_update => true,
  }

  apt::ppa { 'ppa:semiosis/ubuntu-glusterfs-3.5': }
  ->
  package { ['glusterfs-server','glusterfs-client','glusterfs-common']: 
    ensure => installed, 
  }
  
  service { 'glusterfs-server': 
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package['glusterfs-server','glusterfs-client','glusterfs-common'],
  }
  
  case $gluster_nodes {
    '2': {
      $peer_probe = "gluster peer probe ${ip_glu_2}"
      $vol_create_opt = "replica 3 transport tcp ${ip_glu_1}:${brick} ${ip_glu_2}:${brick} force"
      
      exec { "gluster peer probe":
        command => $peer_probe,
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",  
        require => Service["glusterfs-server"],
      }
    }
    '3': {
      $peer_probe1 = "gluster peer probe ${ip_glu_2}"
      $peer_probe2 = "gluster peer probe ${ip_glu_3}"
      $vol_create_opt = "replica 3 transport tcp ${ip_glu_1}:${brick} ${ip_glu_2}:${brick} ${ip_glu_3}:${brick} force" 
      
      exec { "gluster peer probe 1":
        command => $peer_probe1,
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",  
        require => Service["glusterfs-server"],
      }
      
      exec { "gluster peer probe 2":
        command => $peer_probe2,
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",  
        require => Service["glusterfs-server"],
      }
    }
    '4': {
      $peer_probe1 = "gluster peer probe ${ip_glu_2}"
      $peer_probe2 = "gluster peer probe ${ip_glu_3}"
      $peer_probe3 = "gluster peer probe ${ip_glu_4}"  
      $vol_create_opt = "replica 3 transport tcp ${ip_glu_1}:${brick} ${ip_glu_2}:${brick} ${ip_glu_3}:${brick} ${ip_glu_4}:${brick} force" 
      
      exec { "gluster peer probe 1":
        command => $peer_probe1,
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",  
        require => Service["glusterfs-server"],
      }
      
      exec { "gluster peer probe 2":
        command => $peer_probe2,
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",  
        require => Service["glusterfs-server"],
      }
    
      exec { "gluster peer probe 3":
        command => $peer_probe3,
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",  
        require => Service["glusterfs-server"],
      }
    }
    '5': {
      $peer_probe1 = "gluster peer probe ${ip_glu_2}"
      $peer_probe2 = "gluster peer probe ${ip_glu_3}"
      $peer_probe3 = "gluster peer probe ${ip_glu_4}"
      $peer_probe4 = "gluster peer probe ${ip_glu_5}"  
      $vol_create_opt = "replica 3 transport tcp ${ip_glu_1}:${brick} ${ip_glu_2}:${brick} ${ip_glu_3}:${brick} ${ip_glu_4}:${brick} ${ip_glu_5}:${brick} force" 
    
      exec { "gluster peer probe 1":
        command => $peer_probe1,
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",  
        require => Service["glusterfs-server"],
      }
      
      exec { "gluster peer probe 2":
        command => $peer_probe2,
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",  
        require => Service["glusterfs-server"],
      }
    
      exec { "gluster peer probe 3":
        command => $peer_probe3,
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",  
        require => Service["glusterfs-server"],
      }
      
      exec { "gluster peer probe 4":
        command => $peer_probe4,
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",  
        require => Service["glusterfs-server"],
      }
    }
  }
  ->
  exec { "gluster volume create":
    command => "gluster volume create ${gluster_file} ${vol_create_opt}",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",  
    #require => Exec["gluster peer probe"],
  }   
  
  exec { "gluster volume start":
    command => "gluster volume start ${gluster_file}",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",  
    require => Exec["gluster volume create"],
  }
    
}

include glusterfs::mainserver
