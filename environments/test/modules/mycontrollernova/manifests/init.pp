# Install Nova on Controller
class mycontrollernova {
      	
	$admin_token = hiera('admin_token')
	$openstack_db_pwd = hiera('openstack_db_pwd')
	$ip_db = hiera('ip_hap_v')
	$ip_v = hiera('ip_hap_v')
	$ip_v_private = hiera('ip_hap_v_private')
	$rabbit_hosts = hiera('rabbit_hosts')
	$rabbit_user = hiera('rab_def_usr')
 	$rabbit_pass = hiera('rab_def_pwd')
 	$nova_pass = hiera('nova_pass')
	$db_root_password = hiera('db_root_password')
	$management_inteface = hiera('management_inteface')
	$ip_eth1 = inline_template("<%= scope.lookupvar('::ipaddress_${management_inteface}') -%>")

        $enhancers = [ "openstack-nova-api", "openstack-nova-cert", "openstack-nova-conductor", "openstack-nova-console", "openstack-nova-novncproxy", "openstack-nova-scheduler", "python-novaclient" ]
        package { $enhancers: ensure => "installed" }
		

       file { 'nova.conf':
        path	=> '/etc/nova/nova.conf',
	ensure    => present,
        owner     => 'root',
        group     => 'root',
        mode	  => '0644',
        content   => template("mycontrollernova/nova.erb"),
        }
	

	exec { "open port 8773":
                command => "firewall-cmd --permanent --add-port=8773/tcp",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",

        }


	exec { "open port 8774":
                command => "firewall-cmd --permanent --add-port=8774/tcp",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                
        }
	exec { "open port 8775":
                command => "firewall-cmd --permanent --add-port=8775/tcp",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",

        }





	exec { "firewall reload nova":
                command => "firewall-cmd --reload",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",

        }




	if $hostname == 'controller-1' {
    		 
		exec{"check_presence_nova": 
			command => "/usr/bin/test ! -e /root/configlock_nova",
		}
		
  	exec { "clear nova user":
    		command => "mysql -u root  -h ${ip_db} -p${db_root_password} -e \"DELETE FROM mysql.user WHERE User = \'nova\';\" ",
    		path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
		require => Exec["check_presence_nova"],
  	}

  	exec { "drop nova dbs":
    		command => "mysql -u root  -h ${ip_db} -p${db_root_password} -e \"DROP DATABASE IF EXISTS nova;\" ",
    		path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
		require => Exec["check_presence_nova"],
  	}    

  	exec { "db nova":
    		command => "mysql -u root  -h ${ip_db} -p${db_root_password} -e \"CREATE DATABASE nova;\" ",
    		path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    		require => Exec["drop nova dbs"],
  	}
  	exec { "nova privileges":
    		command => "mysql -u root  -h ${ip_db} -p${db_root_password} -e \"GRANT ALL PRIVILEGES ON nova.* TO \'nova\'@\'%\' IDENTIFIED BY \'${openstack_db_pwd}\' WITH GRANT OPTION; FLUSH PRIVILEGES;\" ",
    		path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    		require => Exec["db nova"],
  	}

	exec { "Nova user delete":
                command => "openstack user delete  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 nova",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["check_presence_nova"],
        }


	exec { "Nova user create":
                command => "openstack user create  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 --password ${nova_pass} nova",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
		require => Exec["check_presence_nova"],
        }

	exec { "Nova add role":
                command => "openstack role add  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 --project service --user nova admin",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
		require => Exec["check_presence_nova"],

        }



		exec { "Nova Service delete":
			command => "openstack service delete nova --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0",
            path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
            require => Exec["check_presence_nova"],
        }


        	exec { "Nova Service create":
                	command => "openstack service create --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 --name nova --description \"OpenStack Compute\" compute",
                	path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                	require => Exec["check_presence_nova"],
        	}

        exec { "Nova Endpoint create":
                command => "openstack endpoint create --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 --publicurl http://${ip_v_private}:8774/v2/%\(tenant_id\)s --internalurl http://${ip_v_private}:8774/v2/%\(tenant_id\)s --adminurl http://${ip_v_private}:8774/v2/%\(tenant_id\)s --region RegionOne compute",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
               	require => Exec["check_presence_nova"],
        }

                exec { "populate_db_nova":
                        command => "su -s /bin/sh -c 'nova-manage db sync' nova",
                        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                        require => Exec["check_presence_nova"],
                }


                file { 'configlock_nova':
                path    => '/root/configlock_nova',
                ensure    => present,
                owner     => 'root',
                group     => 'root',
                mode	  => '0644',
                content   => "Delete this file if you want redo the nova database",
                }

	}

        service { "openstack-nova-api":
                ensure  => "running",
               	enable  => "true",
        }

        service { "openstack-nova-cert":
                ensure  => "running",
               	enable  => "true",
        }
        service { "openstack-nova-consoleauth":
                ensure  => "running",
               	enable  => "true",
        }
        service { "openstack-nova-scheduler":
                ensure  => "running",
               	enable  => "true",
        }
        service { "openstack-nova-conductor":
                ensure  => "running",
               	enable  => "true",
        }
        service { "openstack-nova-novncproxy":
                ensure  => "running",
               	enable  => "true",
        }




}



