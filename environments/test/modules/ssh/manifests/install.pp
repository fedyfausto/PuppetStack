class ssh::install {
  
  $sshd_config = hiera('sshd_config')
  
  $port = "22"
  $keyregenerationinterval = "3600"
  $syslogfacility = "AUTHPRIV"
  $loglevel = "info"
  $logingracetime = "120"
  $permitrootlogin = "yes"
  $strictmodes = "yes"
  $rsaauthentication = "yes"
  $pubkeyauthentication = "yes"
  $passwordauthentication = "yes"
  $x11forwarding = "no"
  $printmotd = "no"
  $maxstartups = "10"
  $maxauthtries = "5" 

  package { 'openssh-server':
    ensure        => latest,
    allow_virtual => false,
  }
  
  case $osfamily {
    'Debian': {
      service { 'ssh':
        ensure    => running,
        enable    => true,
        require   => Package["openssh-server"],
        hasstatus => false,
        status    => '/etc/init.d/ssh status|grep running',
        subscribe => File[$sshd_config],
      }
      
      file { $sshd_config:
        owner   => root,
        group   => root,
        mode    => 600,
        content => template("ssh/sshd_config.erb"),
        notify  => Service['ssh']
      }
      
    }
    'RedHat': {
      service { 'sshd':
        ensure    => running,
        enable    => true,
        hasstatus => false,
        subscribe => File[$sshd_config],
        require => Package['openssh-server'],
      }
      
      file { $sshd_config:
        owner   => root,
        group   => root,
        mode    => 600,
        content => template("ssh/sshd_config.erb"),
        notify  => Service['sshd']
      }
    }
  }

}

include ssh::install
