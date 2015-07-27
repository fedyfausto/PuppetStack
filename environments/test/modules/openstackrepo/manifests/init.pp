# Install Openstack dependencies
class openstackrepo {
      	

	package { 'yum-plugin-priorities':
        	ensure        => present,
        	allow_virtual => false,
      	}
     	package { 'epel':
        	ensure        => present,
		source	=> "http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm",
		provider => rpm,
        	allow_virtual => false,
		require       => Package['yum-plugin-priorities'],
      	}

	package { 'kilo':
		ensure        => present,
       		source	=> "http://rdo.fedorapeople.org/openstack-kilo/rdo-release-kilo.rpm",
        	provider => rpm,
        	allow_virtual => false,
        	require       => Package['epel'],
      	}

	package { 'openstack-selinux':
                ensure        => present,
                allow_virtual => false,
		require       => Package['epel'],

        }
}



include openstackrepo
