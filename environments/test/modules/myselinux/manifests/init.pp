# Install SELINUX Policy
class myselinux {

	class { 'selinux':
 		mode => 'permissive'
	}

	exec { "set enforce 0":
        	command => "setenforce 0",
        	path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
	}
}

