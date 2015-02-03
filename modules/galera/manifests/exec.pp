class galera::exec::master {
  if $osfamily == "RedHat" {
    exec { "enforcing mode":
      command => "sudo setenforce 0",
      path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    }
  }
  -> 
  exec { "start galera cluster":
    command => "service mysql start --wsrep-new-cluster",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }
  ->
  class { 'database':
    require => Exec["start galera cluster"],
  }
}

class galera::exec::slave {
  if $osfamily == "RedHat" {
    exec { "enforcing mode":
      command => "sudo setenforce 0",
      path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    }
  }
  ->
  exec { "participate galera cluster":
    command => "service mysql start",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }
} 


