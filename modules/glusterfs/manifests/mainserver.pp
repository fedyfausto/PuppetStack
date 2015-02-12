class glusterfs::mainserver {
  
  require glusterfs::disk
  
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
  
  case $osfamily {
    'Debian': {
      require glusterfs::key
      class { 'apt':
        always_apt_update => true,
      }
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
        before     => Exec['gluster peer probe'],
      }
    }
    'RedHat': {
      include wget
      wget::fetch { "yum repository":
        source      => 'http://download.gluster.org/pub/gluster/glusterfs/LATEST/CentOS/glusterfs-epel.repo',
        destination => '/etc/yum.repos.d/glusterfs-epel.repo',
        timeout     => 0,
        verbose     => false,
      }
      package { ['glusterfs', 'glusterfs-fuse', 'glusterfs-server']: 
        ensure   => installed, 
        provider => 'yum',
        require  => Wget::Fetch['yum repository'],
      }
      service { 'glusterd': 
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        provider   => systemd,
        require    => Package['glusterfs', 'glusterfs-fuse', 'glusterfs-server'],
        before     => Exec['gluster peer probe'],
      }
      ### Firewalld ###
      exec { "enforcing mode":
        command => "sudo setenforce 0",
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",
        notify  => Service['firewalld'],
      }
      service { 'firewalld':
        provider => systemd,
        enable   => true,
        ensure   => running,
      }
      file { 'gfs-firewall-cmd':
        ensure  => 'file',
        source  => 'puppet:///modules/glusterfs/firewall-cmd.sh',
        path    => '/usr/local/bin/gfs_firewall-cmd.sh',
        owner   => 'root',
        group   => 'root',
        mode    => '0744',
        notify  => Exec['gfs-firewall-cmd'],
      }
      exec { 'gfs-firewall-cmd':
        command     => '/usr/local/bin/gfs_firewall-cmd.sh',
        refreshonly => true,
        notify      => Service['glusterd'],
        require     => Service['firewalld'],
      }
    }      
  }

  exec { "gluster peer probe":
    command => $peer_probe,
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",
   # require => Service['glusterfs-server'],
  }

  exec { "gluster volume create":
    command => "gluster volume create ${gluster_file} ${vol_create_opt}",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/", 
    require => Exec["gluster peer probe"],
  }   
  
  exec { "gluster volume start":
    command => "gluster volume start ${gluster_file}",
    unless  => "[ \"`gluster volume info ${gluster_file} | egrep '^Status:'`\" = 'Status: Started' ]",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/", 
    require => Exec["gluster volume create"],
  }
    
}

include glusterfs::mainserver
