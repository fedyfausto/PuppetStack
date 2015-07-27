# Install Horizon Dashboard
class mydashboard {
      	
	$admin_token = hiera('admin_token')
	$openstack_db_pwd = hiera('openstack_db_pwd')
	$ip_db = hiera('ip_hap_v')
	$ip_v = hiera('ip_hap_v')
	$ip_v_private = hiera('ip_hap_v_private')
	$rabbit_hosts = hiera('rabbit_hosts')
        $rabbit_user = hiera('rab_def_usr')
        $rabbit_pass = hiera('rab_def_pwd')
	$controllers = hiera('controller_hosts')
	$db_root_password = hiera('db_root_password')
 	$glance_pass = hiera('glance_pass')


	$enhancers = [ "openstack-dashboard" ]
	package { $enhancers: ensure => "installed" }


#	service { "memcached":
#    		ensure  => "running",
#    		enable  => "true",
#    		require => Package["memcached"],
#	}

       file { 'local_settings':
       		path	=> '/etc/openstack-dashboard/local_settings',
		ensure    => present,
        	owner     => 'root',
        	group     => 'root',
        	mode	  => '0644',
        	content   => template("mydashboard/local_settings.erb"),
        }
	
#	exec { "SELinux httpd":
#                command => "setsebool -P httpd_can_network_connect on",
#                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",
#                 
#        }

        exec { "chown apache":
                command => "chown -R apache:apache /usr/share/openstack-dashboard/static",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",

        }

        exec { "restart apache dashboard":
                command => "service httpd restart",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",

        }

        exec { "restart memchached dashboard":
                command => "service memcached restart",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",

       	}





}



