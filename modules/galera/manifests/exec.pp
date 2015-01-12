class galera::exec {
  
  case $hostname {
 
    'galera-master': {
      exec { "start galera cluster":
        command => "service mysql start --wsrep-new-cluster",
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
      }
      
      class { 'database':
        require => Exec["start galera cluster"],
      }
 
    }

    'galera-1','galera-2': {
      exec { "participate galera cluster":
        command => "service mysql start",
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
      }
    } 

  }
}
