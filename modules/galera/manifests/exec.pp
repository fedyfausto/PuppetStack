class galera::exec::master {
  exec { "start galera cluster":
    command => "service mysql start --wsrep-new-cluster",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }  
  class { 'database':
    require => Exec["start galera cluster"],
  }
}

class galera::exec::slave {
  exec { "participate galera cluster":
    command => "service mysql start",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }
} 


