class ssh::install {

  $sshd_config = hiera('sshd_config')
  
  package { 'openssh-server':
    ensure => installed,
  }

  file { $sshd_config:
    content => template('ssh/sshd_config'),
    require => Package["openssh-server"],
    notify  => Service["ssh"],
    owner   => 'root',
    group   => 'root',
  }

  service { 'ssh':
    ensure    => running,
    enable    => true,
    require   => Package["openssh-server"],
    hasstatus => false,
    status    => '/etc/init.d/ssh status|grep running',
  }

}

include ssh::install
