class galera::dependencies {
  case $osfamily {
    'Debian': {
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
    'RedHat': {
      package { 'MariaDB-Galera-server':
        ensure        => installed,
        allow_virtual => false,
      }
      
      package { 'MariaDB-client':
        ensure        => installed,
        allow_virtual => false,
      }

      package { 'galera':
        ensure        => installed,
        allow_virtual => false,
      }
      
      package { 'rsync':
        ensure        => installed,
        allow_virtual => false,
      }

    }
  }
}


