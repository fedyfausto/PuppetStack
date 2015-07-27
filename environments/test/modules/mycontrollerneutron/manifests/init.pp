# Install Glance
class mycontrollerneutron {
      	
	$admin_token = hiera('admin_token')
	$openstack_db_pwd = hiera('openstack_db_pwd')
	$ip_db = hiera('ip_hap_v')
	$ip_v = hiera('ip_hap_v')
	$ip_v_private = hiera('ip_hap_v_private')
        $db_root_password = hiera('db_root_password')
	$neutron_pass = hiera('neutron_pass')
	$nova_pass = hiera('nova_pass')
	$rabbit_hosts = hiera('rabbit_hosts')
        $rabbit_user = hiera('rab_def_usr')
        $rabbit_pass = hiera('rab_def_pwd')
	$controllers = hiera('controller_hosts')

	$enhancers = [ "openstack-neutron", "openstack-neutron-ml2", "python-neutronclient", "which" ]
	package { $enhancers: ensure => "installed" }


       file { 'neutron.conf':
        path    => '/etc/neutron/neutron.conf',
        ensure    => present,
        owner     => 'root',
        group     => 'root',
        mode	  => '0644',
        content   => template("mycontrollerneutron/neutron.erb"),
        }

       file { 'ml2_conf.ini':
        path    => '/etc/neutron/plugins/ml2/ml2_conf.ini',
        ensure    => present,
        owner     => 'root',
        group     => 'root',
        mode	  => '0644',
        content   => template("mycontrollerneutron/ml2_conf.ini.erb"),
        }

	exec { "open port 9696":
                command => "firewall-cmd --permanent --add-port=9696/tcp",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",

        }
#	exec { "open port 9191":
#                command => "firewall-cmd --permanent --add-port=9191/tcp",
#                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
#        }

	exec { "firewall reload-neutron":
                command => "firewall-cmd --reload",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",

        }


	if $hostname == $controllers[0]  {

    		 
		exec{"check_presence_neutron": 
			command => "/usr/bin/test ! -e /root/configlock_neutron",
		}

		exec { "clear neutron user":
    			command => "mysql -u root -h ${ip_db} -p${db_root_password} -e \"DELETE FROM mysql.user WHERE User = \'neutron\';\" ",
    			path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
			require => Exec["check_presence_neutron"],
  		}

  		exec { "drop neutron dbs":
   	 		command => "mysql -u root -h ${ip_db} -p${db_root_password} -e \"DROP DATABASE IF EXISTS neutron;\" ",
    			path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
			require => Exec["check_presence_neutron"],
  		}   
  		exec { "db neutron":
    			command => "mysql -u root -h ${ip_db} -p${db_root_password} -e \"CREATE DATABASE neutron;\" ",
    			path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    			require => Exec["drop neutron dbs"],
  		}

  		exec { "neutron privileges":
    			command => "mysql -u root -h ${ip_db} -p${db_root_password} -e \"GRANT ALL PRIVILEGES ON neutron.* TO \'neutron\'@\'%\' IDENTIFIED BY \'${openstack_db_pwd}\' WITH GRANT OPTION; FLUSH PRIVILEGES;\" ",
    			path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    			require => Exec["db neutron"],
  		}

                exec { "neutron user delete":
                command => "openstack user delete  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 neutron",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["check_presence_neutron"],
        }

             exec { "neutron user create":
                command => "openstack user create  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 --password ${neutron_pass} neutron",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["check_presence_neutron"],
        }
                exec { "neutron add role":
                command => "openstack role add --project service --user neutron admin --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["check_presence_neutron"],
        }
                exec { "neutron delete service":
                command => "openstack service delete network --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["check_presence_neutron"],
        }
                exec { "neutron add service":
                command => "openstack service create --name neutron --description \"OpenStack Networking\" network --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["check_presence_neutron"],
        }
                exec { "neutron endpoint":
                command => "openstack endpoint create --publicurl http://${ip_v_private}:9696 --internalurl http://${ip_v_private}:9696 --adminurl http://${ip_v_private}:9696 --region RegionOne network --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["check_presence_neutron"],
        }



                exec { "populate_db_neutron":
                        command => "su -s /bin/sh -c \"neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head\" neutron",
                        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                        require => Exec["check_presence_neutron"],
                }

               file { 'configlock_neutron':
                path    => '/root/configlock_neutron',
                ensure    => present,
                owner     => 'root',
                group     => 'root',
               	mode      => '0644',
                content   => "Delete this file if you want redo the neutron configuration",
        	}

	}

	exec { "restart nova services":
                command => "systemctl restart openstack-nova-api.service openstack-nova-scheduler.service openstack-nova-conductor.service",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",

        }

        exec { "delete link plugin":
                command => "rm -rf /etc/neutron/plugin.ini",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
        }


	exec { "link plugin":
                command => "ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
        }


        service { "neutron-server":
                ensure  => "running",
                enable  => "true",
        }
}



include mycontrollerneutron
