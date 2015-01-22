class database::haproxy {

  exec { "clear haproxy users":
    command => "mysql -u root -e \"USE mysql; DELETE FROM mysql.user WHERE (User = \'haproxy_root\' OR User = \'haproxy_check\');\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Exec["start galera cluster"],
  }
  exec { "user haproxy_check":
    command => "mysql -u root -e \"INSERT INTO mysql.user (Host,User) values (\'10.55.1.%\',\'haproxy_check\'); FLUSH PRIVILEGES;\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Exec["clear haproxy users"],
  }
  exec { "user haproxy_root":
    command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON *.* TO \'haproxy_root\'@\'10.55.1.%\' IDENTIFIED BY \'password\' WITH GRANT OPTION; FLUSH PRIVILEGES;\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Exec["clear haproxy users"],
  }
}

include database::haproxy
