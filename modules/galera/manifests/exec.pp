class galera::exec::master {
  if $osfamily == "RedHat" {
    exec { "enforcing mode":
      command => "sudo setenforce 0",
      path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
      notify  => Service['firewalld'],
    }
    service { 'firewalld':
      enable  => true,
      ensure  => stopped,
    }
    package { 'lokkit':
      ensure => installed,
      require => Service['firewalld'],
    }
    file { 'ports':
      ensure  => 'file',
      source  => 'puppet:///modules/galera/lokkit.sh',
      path    => '/usr/local/bin/lokkit.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
      notify  => Exec['run_lokkit'],
      require => Package['lokkit'],
    }
    exec { 'run_lokkit':
      command     => '/usr/local/bin/lokkit.sh',
      refreshonly => true,
    }
  }
   
  exec { "start galera cluster":
    command => "service mysql start --wsrep-new-cluster",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }
  
  class { 'database':
    require => Exec["start galera cluster"],
  }
}

class galera::exec::slave {
  if $osfamily == "RedHat" {
    exec { "enforcing mode":
      command => "sudo setenforce 0",
      path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
      notify  => Service['firewalld'],
    }
    service { 'firewalld':
      enable  => true,
      ensure  => stopped,
    }
    package { 'lokkit':
      ensure => installed,
      require => Service['firewalld'],
    }
    file { 'ports':
      ensure  => 'file',
      source  => 'puppet:///modules/galera/lokkit.sh',
      path    => '/usr/local/bin/lokkit.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
      notify  => Exec['run_lokkit'],
      require => Package['lokkit'],
    }
    exec { 'run_lokkit':
      command     => '/usr/local/bin/lokkit.sh',
      refreshonly => true,
    }
  }
  
  exec { "participate galera cluster":
    command => "service mysql start",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }
} 


