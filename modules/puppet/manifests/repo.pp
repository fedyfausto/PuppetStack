# This will add the repository for Centos 7 or Ubuntu 12.04.
# Modify the file according to your needs.
# There's a better way to do this, but I've no time to look for.

class puppet::repo {

  case $operatingsystem {
    
    /^(Debian|Ubuntu)$/ : {
      exec { "wget":
        command => "wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb",
        path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      }
      exec { "dpkg":
        command => "dpkg -i puppetlabs-release-precise.deb && apt-get update",
        path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        require => Exec["wget"],
      }
      package { 'puppetmaster-passenger':
        ensure  => latest,
	require => Exec['dpkg'],
      }
        
    }
    'RedHat','CentOS' : {
      exec { "addrepo":
        command => "rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm",
        path    => "/usr/bin",
      }    
      package { 'puppet-server':
        ensure        => latest,
        allow_virtual => false,
        require       => Exec['addrepo'],
      }

    }

  }    

}

include puppet::repo
