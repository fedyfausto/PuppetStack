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
	$neutron_pass = hiera('neutron_pass')
	$management_inteface = hiera('management_inteface')
	$db_root_password = hiera('db_root_password')
	$ip_eth1 = inline_template("<%= scope.lookupvar('::ipaddress_${management_inteface}') -%>")
        $tunnel_transfer = hiera('tunnel_transfer')
        $local_ip = inline_template("<%= scope.lookupvar('::ipaddress_${tunnel_transfer}') -%>")


        $enhancers = [ "openstack-nova-compute", "sysfsutils", "openstack-neutron", "openstack-neutron-ml2", "openstack-neutron-openvswitch" ]
        package { $enhancers: ensure => "installed" }
		

        

       file { 'nova.conf':
        path	=> '/etc/nova/nova.conf',
	ensure    => present,
        owner     => 'root',
        group     => 'root',
        mode	  => '0644',
        content   => template("mynova/nova.erb"),
        }
	

	exec { "open vnc ports":
                command => "firewall-cmd --permanent --add-port=5900-5999/tcp",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",

        }


	exec { "firewall reload nova vnc":
                command => "firewall-cmd --reload",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",

        }


       sysctl::value { "net.ipv4.conf.all.rp_filter": value => "0"}
        sysctl::value { "net.ipv4.conf.default.rp_filter": value => "0"}
       sysctl::value { "net.bridge.bridge-nf-call-iptables": value => "1"}
        sysctl::value { "net.bridge.bridge-nf-call-ip6tables": value => "1"}

       file { 'neutron.conf':
        	path    => '/etc/neutron/neutron.conf',
        	ensure    => present,
        	owner     => 'root',
        	group     => 'root',
        	mode	  => '0644',
        	content   => template("mynova/neutron.erb"),
        }

       file { 'ml2_conf.ini':
                path    => '/etc/neutron/plugins/ml2/ml2_conf.ini',
                ensure    => present,
                owner     => 'root',
                group     => 'root',
                mode      => '0644',
                content   => template("mynova/ml2_conf.ini.erb"),
        }

        service { "openvswitch":
                ensure  => "running",
                enable  => "true",
        }


	exec { "delete link plugin":
                command => "rm -rf /etc/neutron/plugin.ini",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
        }


	exec { "link plugin":
                command => "ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
        }

	exec { "resolve OpenVS Issue":
                command => "cp /usr/lib/systemd/system/neutron-openvswitch-agent.service  /usr/lib/systemd/system/neutron-openvswitch-agent.service.orig",

                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
        }

	exec { "resolve OpenVS Issue 2":
                command => "sed -i 's,plugins/openvswitch/ovs_neutron_plugin.ini,plugin.ini,g' /usr/lib/systemd/system/neutron-openvswitch-agent.service",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
        }


        service { "libvirtd":
                ensure  => "running",
               	enable  => "true",
        }

        service { "openstack-nova-compute":
                ensure  => "running",
                enable  => "true",
        }


	service { "neutron-openvswitch-agent":
                ensure  => "running",
                enable  => "true",
        }


}



include mynova
