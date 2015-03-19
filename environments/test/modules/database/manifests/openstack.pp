class database::openstack {

  $openstack_db_pwd = hiera('openstack_db_pwd')

  exec { "clear openstack users":
    command => "mysql -u root -e \"USE mysql; DELETE FROM mysql.user WHERE (User = \'nova\' OR User = \'keystone\' OR User = \'glance\' OR User = \'quantum\' OR User = \'cinder\');\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }

  exec { "drop openstack dbs":
    command => "mysql -u root -e \"USE mysql; DROP DATABASE IF EXISTS nova; DROP DATABASE IF EXISTS keystone; DROP DATABASE IF EXISTS glance; DROP DATABASE IF EXISTS quantum; DROP DATABASE IF EXISTS cinder;\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }    

  exec { "user nova":
    command => "mysql -u root -e \"INSERT INTO mysql.user (Host,User) values (\'%\',\'nova\'); FLUSH PRIVILEGES;\" ",  
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Exec["clear openstack users"],
  }
  exec { "user keystone":
    command => "mysql -u root -e \"INSERT INTO mysql.user (Host,User) values (\'%\',\'keystone\'); FLUSH PRIVILEGES;\" ",  
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Exec["clear openstack users"],
  }
  exec { "user glance":
    command => "mysql -u root -e \"INSERT INTO mysql.user (Host,User) values (\'%\',\'glance\'); FLUSH PRIVILEGES;\" ",  
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Exec["clear openstack users"],
  }
  exec { "user quantum":
    command => "mysql -u root -e \"INSERT INTO mysql.user (Host,User) values (\'%\',\'quantum\'); FLUSH PRIVILEGES;\" ",  
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Exec["clear openstack users"],
  }
  exec { "user cinder":
    command => "mysql -u root -e \"INSERT INTO mysql.user (Host,User) values (\'%\',\'cinder\'); FLUSH PRIVILEGES;\" ",  
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Exec["clear openstack users"],
  }

  exec { "db nova":
    command => "mysql -u root -e \"CREATE DATABASE nova;\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Exec["drop openstack dbs"],
  }
  exec { "db keystone":
    command => "mysql -u root -e \"CREATE DATABASE keystone;\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Exec["drop openstack dbs"],
  }
  exec { "db glance":
    command => "mysql -u root -e \"CREATE DATABASE glance;\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Exec["drop openstack dbs"],
  }
  exec { "db quantum":
    command => "mysql -u root -e \"CREATE DATABASE quantum;\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Exec["drop openstack dbs"],
  }
  exec { "db cinder":
    command => "mysql -u root -e \"CREATE DATABASE cinder;\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Exec["drop openstack dbs"],
  }
    
  exec { "nova privileges":
    command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON nova.* TO \'nova\'@\'%\' IDENTIFIED BY \'${openstack_db_pwd}\' WITH GRANT OPTION; FLUSH PRIVILEGES;\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => [ Exec["user nova"], Exec["db nova"] ],
  }
  exec { "keystone privileges":
    command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON keystone.* TO \'keystone\'@\'%\' IDENTIFIED BY \'${openstack_db_pwd}\' WITH GRANT OPTION; FLUSH PRIVILEGES;\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => [ Exec["user keystone"], Exec["db keystone"] ],
  }
  exec { "glance privileges":
    command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON glance.* TO \'glance\'@\'%\' IDENTIFIED BY \'${openstack_db_pwd}\' WITH GRANT OPTION; FLUSH PRIVILEGES;\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => [ Exec["user glance"], Exec["db glance"] ],
  }
  exec { "quantum privileges":
    command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON quantum.* TO \'quantum\'@\'%\' IDENTIFIED BY \'${openstack_db_pwd}\' WITH GRANT OPTION; FLUSH PRIVILEGES;\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => [ Exec["user quantum"], Exec["db quantum"] ],
  }
  exec { "cinder privileges":
    command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON cinder.* TO \'cinder\'@\'%\' IDENTIFIED BY \'${openstack_db_pwd}\' WITH GRANT OPTION; FLUSH PRIVILEGES;\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => [ Exec["user cinder"], Exec["db cinder"] ],
  }
    
}

include database::openstack
