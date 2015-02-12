class glusterfs::disk {

  $disk = hiera('disk')
  $mount_point = hiera('mount_point')

  package { 'xfsprogs':
    ensure        => installed,
    allow_virtual => false,
  }

  exec { "create the partition":
    command => "echo -e \"o\nn\np\n1\n\n\nw\" | fdisk ${disk}",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }

  exec { "create the XFS file system":
    command => "mkfs.xfs -f -L media ${disk}1",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => [ Package['xfsprogs'], Exec['create the partition'] ],
  }

  file { $mount_point:
    ensure  => directory,
  }
  
  mount { $mount_point:
    device  => "${disk}1",
    fstype  => 'xfs',
    options => 'defaults',
    ensure  => mounted,
    require => [ File[$mount_point], Exec["create the XFS file system"] ],
  }
  
  file { "${mount_point}/brick":
    ensure  => directory,
    require => Mount[$mount_point],
  }
  
#  file_line { 'fstab rule':
#    path => '/etc/fstab',
#    line => "${disk} ${mount_point} xfs defaults 0 0",
#  }

}

include glusterfs::disk
