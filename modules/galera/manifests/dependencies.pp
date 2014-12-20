class galera::dependencies {

  contain apt
      
  package { 'python-software-properties':
    ensure => installed,
  }

  apt::source { 'mariadb':
    location    => 'http://mirror.jmu.edu/pub/mariadb/repo/5.5/ubuntu',
    release     => 'precise',
    repos       => 'main',
    key         => '0xcbcb082a1bb943db',
    key_server  => 'keyserver.ubuntu.com',
    include_src => 'true',
    include_deb => 'true',
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


