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
      }
    }      
  }
  
}

include glusterfs::server
