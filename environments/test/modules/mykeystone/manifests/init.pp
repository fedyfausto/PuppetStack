# Install Keystone
class mykeystone {
      	
	$admin_token = hiera('admin_token')
	$openstack_db_pwd = hiera('openstack_db_pwd')
	$ip_db = hiera('ip_hap_v')
	$ip_v = hiera('ip_hap_v')
	$ip_v_private = hiera('ip_hap_v_private')
	$rabbit_hosts = hiera('rabbit_hosts')
        $rabbit_user = hiera('rab_def_usr')
        $rabbit_pass = hiera('rab_def_pwd')
	$db_root_password = hiera('db_root_password')
 	$glance_pass = hiera('glance_pass')



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


	$enhancers = [ "openstack-keystone", "httpd", "mod_wsgi", "python-openstackclient", "memcached", "python-memcached" ]
	package { $enhancers: ensure => "installed" }


	service { "memcached":
    		ensure  => "running",
    		enable  => "true",
    		require => Package["memcached"],
	}

# Create an openrc file
	file { '/root/admin-openrc':
  	ensure    => present,
  	owner     => 'root',
  	group     => 'root',
  	mode      => '0600',
  	content   => "
		export OS_PROJECT_DOMAIN_ID=default
		export OS_USER_DOMAIN_ID=default
		export OS_PROJECT_NAME=admin
		export OS_TENANT_NAME=admin
		export OS_USERNAME=admin
		export OS_PASSWORD=admin
		export OS_AUTH_URL=http://${ip_v_private}:35357/v3
		export OS_IMAGE_API_VERSION=2		
		"
	}

        file { '/root/demo-openrc':
        ensure    => present,
        owner     => 'root',
        group     => 'root',
        mode	  => '0600',
        content   => "
                export OS_PROJECT_DOMAIN_ID=default
                export OS_USER_DOMAIN_ID=default
                export OS_PROJECT_NAME=demo
                export OS_TENANT_NAME=demo
                export OS_USERNAME=demo
                export OS_PASSWORD=demo
                export OS_AUTH_URL=http://${ip_v_private}:35357/v3
		export OS_IMAGE_API_VERSION=2
                "
        }


       file { 'keystone.conf':
        path	=> '/etc/keystone/keystone.conf',
	ensure    => present,
        owner     => 'root',
        group     => 'root',
        mode	  => '0644',
        content   => template("mykeystone/keystone.erb"),
        }
	
       file { 'httpd.conf':
        path    => '/etc/httpd/conf/httpd.conf',
        ensure    => present,
        owner     => 'root',
        group     => 'root',
        mode      => '0644',
        content   => template("mykeystone/httpd.erb"),
        }

       file { 'wsgi-keystone.conf':
        path    => '/etc/httpd/conf.d/wsgi-keystone.conf',
        ensure    => present,
        owner     => 'root',
        group     => 'root',
        mode	  => '0644',
        content   => template("mykeystone/wsgi-keystone.erb"),
        }

	exec { "mkdir_wsgi":
                command => "mkdir -p /var/www/cgi-bin/keystone",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                 
        }

        exec { "curl":
                command => "curl http://git.openstack.org/cgit/openstack/keystone/plain/httpd/keystone.py?h=stable/kilo | tee /var/www/cgi-bin/keystone/main /var/www/cgi-bin/keystone/admin",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["mkdir_wsgi"],
        }
        exec { "chown":
                command => "chown -R keystone:keystone /var/www/cgi-bin/keystone",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["curl"],
        }
        exec { "chmod":
               	command => "chmod 755 /var/www/cgi-bin/keystone/*",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["chown"],
        }

	exec { "open port 5000":
                command => "firewall-cmd --permanent --add-port=5000/tcp",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                
        }

        exec { "open port 35357":
                command => "firewall-cmd --permanent --add-port=35357/tcp",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                
        }
        exec { "open port 80":
                command => "firewall-cmd --permanent --add-port=80/tcp",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                
        }

	exec { "firewall reload":
                command => "firewall-cmd --reload",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",

        }




        service { "httpd":
                ensure  => "running",
                enable  => "true",
                require => Exec["chmod"],
        }


	if $hostname == 'controller-1' {
    		 
		exec{"check_presence": 
			command => "/usr/bin/test ! -e /root/configlock_keystone",
		}
		

		notify { "Il file non esiste":
			require => Exec["check_presence"],
        }
  	exec { "clear keystone user":
    		command => "mysql -u root -h ${ip_db} -p${db_root_password} -e \"DELETE FROM mysql.user WHERE User = \'keystone\';\" ",
    		path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
		require => Exec["check_presence"],
  	}

	exec { "select keystone user":
                command => "mysql -u root -h ${ip_db} -p${db_root_password} -e \"SELECT User, Host FROM mysql.user;\" ",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["check_presence"],
        }

  	exec { "drop openstack keystone":
    		command => "mysql -u root -h ${ip_db} -p${db_root_password} -e \"USE mysql; DROP DATABASE IF EXISTS keystone;\" ",
    		path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
   		require => Exec["check_presence"],
		}
  	#exec { "user keystone":
    	#	command => "mysql -u root -h ${ip_db} -p${db_root_password} -e \"INSERT INTO mysql.user (Host,User) values (\'%\',\'keystone\'); FLUSH PRIVILEGES;\" ",  
    	#	path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    	#	require => Exec["clear keystone user"],
  	#}

  	exec { "db keystone":
    		command => "mysql -u root -h ${ip_db} -p${db_root_password} -e \"CREATE DATABASE keystone;\" ",
    		path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    		require => Exec["drop openstack keystone"],
 	}
  	exec { "keystone privileges":
    		command => "mysql -u root -h ${ip_db} -p${db_root_password} -e \"GRANT ALL PRIVILEGES ON keystone.* TO \'keystone\'@\'%\' IDENTIFIED BY \'${openstack_db_pwd}\' WITH GRANT OPTION; FLUSH PRIVILEGES;\" ",
    		path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    		#require => [ Exec["user keystone"], Exec["db keystone"] ],
    		require => Exec["db keystone"],
  }

        exec { "populate_db":
                command => "su -s /bin/sh -c 'keystone-manage db_sync' keystone",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
		 require => Exec["check_presence"],
        }

		exec { "Service delete":
			command => "openstack service delete keystone --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0",
            path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
            require => Exec["check_presence"],
        }


        	exec { "Service create":
                	command => "openstack service create --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 --name keystone --description \"OpenStack Identity\" identity",
                	path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                	require => Exec["check_presence"],
        	}

        exec { "Endpoint create":
                command => "openstack endpoint create --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 --publicurl http://${ip_v_private}:5000/v2.0 --internalurl http://${ip_v_private}:5000/v2.0 --adminurl http://${ip_v_private}:35357/v2.0 --region RegionOne identity",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
               	require => Exec["Service create"],
        }

        exec { "Admin Project delete":
                command => "openstack project delete  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 admin",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["Service create"],
        }


	exec { "Admin Project create":
                command => "openstack project create  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 --description \"Admin Project\" admin",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["Service create"],
        }

        exec { "Admin user delete":
                command => "openstack user delete  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 admin",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["Admin Project create"],
        }


        exec { "Admin user create":
                command => "openstack user create  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 --password admin admin",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["Admin Project create"],
        }

        exec { "Admin role delete":
                command => "openstack role delete  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 admin",
               	path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["Admin user create"],
        }

        exec { "Admin role create":
                command => "openstack role create  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 admin",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["Admin user create"],
        }

        exec { "Admin role/project":
                command => "openstack role add --project admin --user admin  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 admin",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["Admin role create"],
        }

        exec { "Service project delete":
                command => "openstack project delete --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 service",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["Admin role/project"],
        }

        exec { "Service project create":
                command => "openstack project create --description \"Service Project\" service --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["Admin role/project"],
        }

        exec { "Demo project delete":
                command => "openstack project delete --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 demo",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["Admin role/project"],
        }

        exec { "Demo project create":
                command => "openstack project create --description \"Demo Project\" demo --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["Admin role/project"],
        }

		exec { "Demo user delete":
                command => "openstack user delete  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 demo",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["Demo project create"],
        }


		exec { "Demo user create":
                command => "openstack user create  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 --password demo demo",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["Demo project create"],
        }

		exec { "User role delete":
                command => "openstack role delete  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 user",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["Demo user create"],
        }

		exec { "User role create":
                command => "openstack role create  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 user",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["Demo user create"],
        }

		exec { "User role/project":
                command => "openstack role add --project demo --user demo  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 user",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["User role create"],
        }



                file { 'configlock':
                path    => '/root/configlock_keystone',
                ensure    => present,
                owner     => 'root',
                group     => 'root',
                mode	  => '0644',
                content   => "Delete this file if you want redo the keystone database",
                }

	}


}



