class database::haproxy {
  
  $ip_hap_1 = hiera('ip_hap_1') 
  $ip_hap_2 = hiera('ip_hap_2') 
   
  exec { "clear haproxy users":
     command => "mysql -u root -e \"USE mysql; DELETE FROM mysql.user WHERE (User = \'haproxy_root\' OR User = \'haproxy_check\');\" ",
     path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
     require => Exec["start galera cluster"],
  }
  exec { "user haproxy_check_hap_1":
     command => "mysql -u root -e \"INSERT INTO mysql.user (Host,User) values (\'${ip_hap_1}\',\'haproxy_check\'); FLUSH PRIVILEGES;\" ",
     path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
     require => Exec["clear haproxy users"],
  }
  exec { "user haproxy_check_hap_2":
     command => "mysql -u root -e \"INSERT INTO mysql.user (Host,User) values (\'${ip_hap_2}\',\'haproxy_check\'); FLUSH PRIVILEGES;\" ",
     path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
     require => Exec["clear haproxy users"],
  }
  exec { "user haproxy_root_hap_1":
     command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON *.* TO \'haproxy_root\'@\'${ip_hap_1}\' IDENTIFIED BY \'password\' WITH GRANT OPTION; FLUSH PRIVILEGES;\" ",
     path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
     require => Exec["clear haproxy users"],
  }
  exec { "user haproxy_root_hap_2":
     command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON *.* TO \'haproxy_root\'@\'${ip_hap_2}\' IDENTIFIED BY \'password\' WITH GRANT OPTION; FLUSH PRIVILEGES;\" ",
     path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
     require => Exec["clear haproxy users"],
  }

}

include database::haproxy
