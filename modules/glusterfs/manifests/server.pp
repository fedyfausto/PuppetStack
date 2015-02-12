class glusterfs::server {
  
  require glusterfs::disk

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
      exec { "enforcing mode":
        command => "setenforce 0",
        path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        before  => File['gfs-firewall-cmd'],
      }
      file { 'gfs-firewall-cmd':
        ensure  => 'file',
        source  => 'puppet:///modules/glusterfs/firewall-cmd.sh',
        path    => '/usr/local/bin/gfs_firewall-cmd.sh',
        owner   => 'root',
        group   => 'root',
        mode    => '0744',
        before  => Exec['gfs-firewall-cmd'],
      }
      exec { 'gfs-firewall-cmd':
        command     => '/usr/local/bin/gfs_firewall-cmd.sh',
        refreshonly => true,
        notify      => [Service['firewalld'],Service['glusterd']],
      }
      service { 'firewalld':
        provider => systemd,
        enable   => true,
        ensure   => running,
      }
      service { 'glusterd': 
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        provider   => systemd,
        require    => Package['glusterfs', 'glusterfs-fuse', 'glusterfs-server'],
      }
    }      
  }
}

include glusterfs::server
