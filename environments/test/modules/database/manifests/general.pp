class database::general {

  $collation_server = hiera('collation_server')
  $init_connect = hiera('init_connect')
  $character_set_server = hiera('character_set_server')
  $db_root_password = hiera('db_root_password')  
  case $osfamily {
    'Debian': {
      exec { "grant privileges":
        command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON *.* TO \'debian-sys-maint\'@\'localhost\' IDENTIFIED BY \'Xt9JBkj4HOKK52AI\';\" ",  
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
      }
      file { 'my.cnf':
        path    => hiera('deb_my_cnf_path'),
        content => template('database/deb_my.erb'),
        ensure  => present,
      }
    }
    'RedHat': {
      exec { "grant privileges":
        command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON *.* TO \'root\'@\'%\' IDENTIFIED BY \'${db_root_password}\';\" ",  
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
      }
      exec { "grant privileges root@%":
        command => "mysql -u root -e \"UPDATE mysql.user SET Grant_priv=\'Y\', Super_priv=\'Y\' WHERE User=\'root\';FLUSH PRIVILEGES;GRANT ALL ON *.* TO \'root\'@\'%\';\" ",
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
      }

      file { 'my.cnf':
        path    => hiera('red_my_cnf_path'),
        content => template('database/red_my.erb'),
        ensure  => present,
      }
    }
  }
  
  

}

include database::general
