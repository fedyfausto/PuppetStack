class ssh::install {
  
  $sshd_config = hiera('sshd_config')

  package { 'openssh-server':
    ensure        => installed,
    allow_virtual => false,
  }
  
  
  case $osfamily {
    'Debian': {
      file { $sshd_config:
        #content => template('ssh/sshd_config'),
        require => Package["openssh-server"],
        notify  => Service["ssh"],
        owner   => 'root',
        group   => 'root',
        ensure  => present,
      }
      
      file_line { 'PermitRootLogin yes':
        path => $sshd_config,  
        line => 'PermitRootLogin yes',
        match   => "^*PermitRootLogin*$",
      }
      
      service { 'ssh':
        ensure    => running,
        enable    => true,
        require   => Package["openssh-server"],
        hasstatus => false,
        status    => '/etc/init.d/ssh status|grep running',
      }
    }
    'RedHat': {
      file { $sshd_config:
        #content => template('ssh/sshd_config'),
        require => Package["openssh-server"],
        notify  => Service["sshd"],
        owner   => 'root',
        group   => 'root',
        ensure  => present,
      }
      
      file_line { 'PermitRootLogin yes':
        path => $sshd_config,  
        line => 'PermitRootLogin yes',
        match   => "^*PermitRootLogin*$",
      }
    
      service { 'sshd':
        ensure    => running,
        enable    => true,
        require   => Package["openssh-server"],
        hasstatus => false,
      }
    }
  }

}

include ssh::install
