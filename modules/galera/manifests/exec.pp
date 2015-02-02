class galera::exec::master {
  case $osfamily {
    'Debian': {
      exec { "start galera cluster":
        command => "service mysql start --wsrep-new-cluster",
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
      }  
      class { 'database':
        require => Exec["start galera cluster"],
      } 
    }
    'RedHat': {
      exec { "start galera cluster":
        command => "mysql bootstrap",
        path    => "/etc/init.d",
      }
      class { 'database':
        require => Exec["start galera cluster"],
      }
    }
  }
}

class galera::exec::slave {
  case $osfamily {
    'Debian': {
      exec { "participate galera cluster":
        command => "service mysql start",
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
      }
    }
    'RedHat': {
      exec { "participate galera gluster":
        command => "mysql start",
        path    => "/etc/init.d",
      }
    }
  }
} 


