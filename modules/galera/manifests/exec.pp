class galera::exec::master {
  if $osfamily == "RedHat" {
    exec { "enforcing mode":
      command => "sudo setenforce 0",
      path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
      notify  => File['iptables'],
    }
  
    file { 'iptables':
      ensure  => 'file',
      source  => 'puppet:///modules/galera/iptables.sh',
      path    => '/usr/local/bin/iptables.sh',
      owner   => 'root'
      group   => 'root'
      mode    => '0744',
      notify  => Exec['run_iptablest'],
    }
  
    exec { 'run_iptables':
      command     => '/usr/local/bin/iptables.sh',
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
      notify  => File['iptables'],
    }
  
    file { 'iptables':
      ensure  => 'file',
      source  => 'puppet:///modules/galera/iptables.sh',
      path    => '/usr/local/bin/iptables.sh',
      owner   => 'root'
      group   => 'root'
      mode    => '0744',
      notify  => Exec['run_iptablest'],
    }
  
    exec { 'run_iptables':
      command     => '/usr/local/bin/iptables.sh',
      refreshonly => true,
    }
  }
  
  exec { "participate galera cluster":
    command => "service mysql start",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }
} 


