class database::general {

  #$collation_server = hiera('collation_server')
  #$init_connect = hiera('collation_server')
  #$character_set_server = hiera('character_set_server')
  
  case $osfamily {
    'Debian': {
      exec { "grant privileges":
        command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON *.* TO \'debian-sys-maint\'@\'localhost\' IDENTIFIED BY \'Xt9JBkj4HOKK52AI\';\" ",  
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
      }
    }
    'RedHat': {
      exec { "grant privileges":
        command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON *.* TO \'root\'@\'%\' IDENTIFIED BY \'password\';\" ",  
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
      }
    }
  }
  
  #file { 'my.cnf':
  #  path    => hiera('my_cnf_path'),
  #  content => template('database/my.erb'),
  #  ensure  => present,
  #}

}

include database::general
