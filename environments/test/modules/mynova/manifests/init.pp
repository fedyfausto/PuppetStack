# Install Nova on Compute
class mynova {
      	
	$admin_token = hiera('admin_token')
	$openstack_db_pwd = hiera('openstack_db_pwd')
	$ip_db = hiera('ip_hap_v')
	$ip_v = hiera('ip_hap_v')
	$ip_v_private = hiera('ip_hap_v_private')
	$rabbit_hosts = hiera('rabbit_hosts')
	$rabbit_user = hiera('rab_def_usr')
 	$rabbit_pass = hiera('rab_def_pwd')
 	$nova_pass = hiera('nova_pass')
	$management_inteface = hiera('management_inteface')
	$db_root_password = hiera('db_root_password')
	$ip_eth1 = inline_template("<%= scope.lookupvar('::ipaddress_${management_inteface}') -%>")

	package { 'yum-plugin-priorities':
                ensure        => present,
                allow_virtual => false,
        }
	package { 'epel':
                ensure        => present,
                source  => "http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm",
                provider => rpm,
                allow_virtual => false,
                require       => Package['yum-plugin-priorities'],
        }


	package { 'kilo':
                ensure        => present,
                source  => "http://rdo.fedorapeople.org/openstack-kilo/rdo-release-kilo.rpm",
                provider => rpm,
                allow_virtual => false,
                require       => Package['epel'],
        }


        $enhancers = [ "openstack-nova-compute", "sysfsutils" ]
        package { $enhancers: ensure => "installed" }
		

        

       file { 'nova.conf':
        path	=> '/etc/nova/nova.conf',
	ensure    => present,
        owner     => 'root',
        group     => 'root',
        mode	  => '0644',
        content   => template("mynova/nova.erb"),
        }
	

#	exec { "open port 8773":
#                command => "firewall-cmd --permanent --add-port=8773/tcp",
#                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
#
#        }


#	exec { "firewall reload nova":
#                command => "firewall-cmd --reload",
#                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
#
#        }




        service { "libvirtd":
                ensure  => "running",
               	enable  => "true",
        }

        service { "openstack-nova-compute":
                ensure  => "running",
                enable  => "true",
        }


}



