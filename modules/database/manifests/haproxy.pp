class database::haproxy {

  $ip_hap_v = hiera('ip_hap_v')

  exec { "clear haproxy users":
    command => "mysql -u root -e \"USE mysql; DELETE FROM mysql.user WHERE (User = \'haproxy_root\' OR User = \'haproxy_check\');\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Exec["start galera cluster"],
  }
  exec { "user haproxy_check":
    command => "mysql -u root -e \"INSERT INTO mysql.user (Host,User) values (\'${ip_hap_v}\',\'haproxy_check\'); FLUSH PRIVILEGES;\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Exec["clear haproxy users"],
  }
  exec { "user haproxy_root":
    command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON *.* TO \'haproxy_root\'@\'${ip_hap_v}\' IDENTIFIED BY \'password\' WITH GRANT OPTION; FLUSH PRIVILEGES;\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Exec["clear haproxy users"],
  }
}

include database::haproxy
