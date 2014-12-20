class galera::dependencies {

  package { 'python-software-properties':
    ensure => installed,
  }

  package { 'mariadb-galera-server':
    ensure => installed,
  }

  package { 'galera':
    ensure => installed,
  }

  package { 'rsync':
    ensure => installed,
  }
    
}


