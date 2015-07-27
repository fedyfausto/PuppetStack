# Install Galera Client
class galeraclient {

 notify{"Sto eseguendo" : }
      	
	if $hostname == 'controller-1' {
        	yumrepo { 'MariaDB':
        		name     => 'MariaDB',
        		baseurl  => 'http://yum.mariadb.org/10.0/centos7-amd64',
        		gpgkey   => 'https://yum.mariadb.org/RPM-GPG-KEY-MariaDB',
        		gpgcheck => true,
        	}

      		package {'MariaDB-client':
        		ensure        => installed,
        		allow_virtual => false,
        		provider      => yum,
      		}
  	}

}



include galeraclient
