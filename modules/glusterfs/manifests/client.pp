class glusterfs::client {
  
  $ip_glu_1 = hiera('ip_glu_1')
  $mount_point = hiera('mount_point')
  $gluster_file = hiera('gluster_file')
  
  case $osfamily {
    'Debian': {
      require glusterfs::key
      class { 'apt':
        always_apt_update => true,
      }
      package { ['glusterfs-client','glusterfs-common']: 
        ensure => installed, 
      }
      
      # DISABLING FIREWALL
      #exec { 'disabling firewall':
      #  command => 'ufw disable',
      #  path    => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin",
      #  require => Service['glusterfs-server'],
      #}
      
      #exec { 'network reload':
      #  command => 'networking force-reload',
      #  path    => "/etc/init.d/",
      #  require => Exec['disabling firewall'],
      #}
    }
    'RedHat': {
      include wget
      wget::fetch { "yum repository":
        source      => 'http://download.gluster.org/pub/gluster/glusterfs/LATEST/CentOS/glusterfs-epel.repo',
        destination => '/etc/yum.repos.d/glusterfs-epel.repo',
        timeout     => 0,
        verbose     => false,
        require     => Exec['gfs-firewall-cmd'],
      }
      package { ['glusterfs', 'glusterfs-fuse']: 
        ensure   => installed, 
        provider => 'yum',
        require  => Wget::Fetch['yum repository'],
      }
      
      ### Firewalld ###
      file { 'gfs-firewall-cmd':
        ensure  => 'file',
        source  => 'puppet:///modules/glusterfs/firewall-cmd.sh',
        path    => '/usr/local/bin/gfs_firewall-cmd.sh',
        owner   => 'root',
        group   => 'root',
        mode    => '0744',
        before  => Exec['gfs-firewall-cmd'],
      }
      exec { "enforcing mode":
        command => "setenforce 0",
        path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        before  => File['gfs-firewall-cmd'],
      }
      exec { 'gfs-firewall-cmd':
        command     => '/usr/local/bin/gfs_firewall-cmd.sh',
        #refreshonly => true,
        #notify      => Service['glusterd'],
      }
      
    }
  }
  
  file { "/mnt/${gluster_file}": 
    ensure => directory, 
  } 
  
  mount { "/mnt/${gluster_file}":
    ensure   => 'mounted',
    options  => 'defaults',
    fstype   => 'glusterfs',
    device   => "${ip_glu_1}:/${gluster_file}",
    require  => File["/mnt/${gluster_file}"],
    remounts => false,  
    atboot   => true,
}

}

include glusterfs::client
