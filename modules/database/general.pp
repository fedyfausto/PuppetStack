class database::general {

  exec { "grant privileges":
    command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON *.* TO \'debian-sys-maint\'@\'localhost\' IDENTIFIED BY \'Xt9JBkj4HOKK52AI\';\" ",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }

}

include database::general
