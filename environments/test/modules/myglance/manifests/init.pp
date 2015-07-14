# Install Glance
class myglance {
      	
	$admin_token = hiera('admin_token')
	$openstack_db_pwd = hiera('openstack_db_pwd')
	$ip_db = hiera('ip_hap_v')
	$ip_v = hiera('ip_hap_v')
	$ip_v_private = hiera('ip_hap_v_private')
        $db_root_password = hiera('db_root_password')
	$glance_pass = hiera('glance_pass')
	$rabbit_hosts = hiera('rabbit_hosts')
	$ip_storage_images = hiera('ip_storage_images')
	$remote_image_dir = hiera('remote_image_dir')
	$glance_image_dir = hiera('glance_image_dir')

	$enhancers = [ "openstack-glance", "python-glance", "python-glanceclient" ]
	package { $enhancers: ensure => "installed" }
notify{"PPP" : }

          yumrepo { 'mariadb glance':
#            name     => 'MariaDB',
            baseurl  => 'http://yum.mariadb.org/10.0/centos7-amd64',
            gpgkey   => 'https://yum.mariadb.org/RPM-GPG-KEY-MariaDB',
            gpgcheck => true,
          }

      package {'MariaDB-client glance':
        ensure        => installed,
        allow_virtual => false,
        provider      => yum,
      }

      package {'nfs-utils':
        ensure        => installed,
        allow_virtual => false,
        provider      => yum,
      }

	exec { "make shared image dir":
        	command => "mkdir -p ${glance_image_dir}",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
	}

        service { "rpcbind":
                ensure  => "running",
                enable  => "true",
        }

        service { "nfs-server":
                ensure  => "running",
                enable  => "true",
        }

        exec { "mount remote image directory":
                command => "mount -t nfs ${ip_storage_images}:${remote_image_dir} ${glance_image_dir}",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
        }

	fstab { 'Another test fstab entry':
  		source => ' ${ip_storage_images}:${remote_image_dir}',
  		dest   => '${glance_image_dir}',
  		type   => 'nfs',
  		opts   => 'defaults',
  		dump   => 0,
  		passno => 0,
	}


       file { 'glance-api.conf':
        path    => '/etc/glance/glance-api.conf',
        ensure    => present,
        owner     => 'root',
        group     => 'root',
        mode	  => '0644',
        content   => template("myglance/glance-api.erb"),
        }

       file { 'glance-registry.conf':
        path    => '/etc/glance/glance-registry.conf',
        ensure    => present,
        owner     => 'root',
        group     => 'root',
        mode	  => '0644',
        content   => template("myglance/glance-registry.erb"),
        }

	exec { "open port 9292":
                command => "firewall-cmd --permanent --add-port=9292/tcp",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",

        }
	exec { "open port 9191":
                command => "firewall-cmd --permanent --add-port=9191/tcp",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",

        }
	exec { "firewall reload-glance":
                command => "firewall-cmd --reload",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",

        }


	if $hostname == 'controller-1' {
    		 
		exec{"check_presence_glance": 
			command => "/usr/bin/test ! -e /root/configlock_glance",
		}

		exec { "clear glance user":
    			command => "mysql -u root -h ${ip_db} -p${db_root_password} -e \"DELETE FROM mysql.user WHERE User = \'glance\';\" ",
    			path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
			require => Exec["check_presence_glance"],
  		}

  		exec { "drop glance dbs":
   	 		command => "mysql -u root -h ${ip_db} -p${db_root_password} -e \"DROP DATABASE IF EXISTS glance;\" ",
    			path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
			require => Exec["check_presence_glance"],
  		}   
  		exec { "db glance":
    			command => "mysql -u root -h ${ip_db} -p${db_root_password} -e \"CREATE DATABASE glance;\" ",
    			path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    			require => Exec["drop glance dbs"],
  		}

  		exec { "glance privileges":
    			command => "mysql -u root -h ${ip_db} -p${db_root_password} -e \"GRANT ALL PRIVILEGES ON glance.* TO \'glance\'@\'%\' IDENTIFIED BY \'${openstack_db_pwd}\' WITH GRANT OPTION; FLUSH PRIVILEGES;\" ",
    			path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    			require => Exec["db glance"],
  		}

                exec { "Glance user delete":
                command => "openstack user delete  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 glance",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["check_presence_glance"],
        }

             exec { "Glance user create":
                command => "openstack user create  --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0 --password ${glance_pass} glance",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["check_presence_glance"],
        }
                exec { "Glance add role":
                command => "openstack role add --project service --user glance admin --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["check_presence_glance"],
        }
                exec { "Glance delete service":
                command => "openstack service delete image --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["check_presence_glance"],
        }
                exec { "Glance add service":
                command => "openstack service create --name glance --description \"OpenStack Image service\" image --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["check_presence_glance"],
        }
                exec { "Glance endpoint":
                command => "openstack endpoint create --publicurl http://${ip_v_private}:9292 --internalurl http://${ip_v_private}:9292 --adminurl http://{ip_v_private}:9292 --region RegionOne image --os-token ${admin_token} --os-url http://127.0.0.1:35357/v2.0",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                require => Exec["check_presence_glance"],
        }

                exec { "populate_db_glance":
                        command => "su -s /bin/sh -c 'glance-manage db_sync' glance",
                        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
                        require => Exec["check_presence_glance"],
                }

               file { 'configlock_glance':
                path    => '/root/configlock_glance',
                ensure    => present,
                owner     => 'root',
                group     => 'root',
               	mode      => '0644',
                content   => "Delete this file if you want redo the glance configuration",
        	}

	}

        service { "openstack-glance-api":
                ensure  => "running",
                enable  => "true",
        }
	
        service { "openstack-glance-registry":
                ensure  => "running",
                enable  => "true",
        }


}



