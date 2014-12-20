class galera::exec {
  case $hostname {
 
    'galera-master': {
       exec { "start galera cluster":
         command => "service mysql start --wsrep-new-cluster",
         path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
       }

#       exec { "grant privileges":
#         command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON *.* TO \'debian-sys-maint\'@\'localhost\' IDENTIFIED BY \'Xt9JBkj4HOKK52AI\';\" ",
#         path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
#       }

    }  

    'galera-1','galera-2': {
       exec { "participate galera cluster":
         command => "service mysql start",
         path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
       }  
    }

  }
}
