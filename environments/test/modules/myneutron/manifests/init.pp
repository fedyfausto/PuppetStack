# Install neutron
class myneutron {
	require ::disablefirewall
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
	$tunnel_interface = hiera('tunnel_transfer')
	$external_interface = hiera('external_inteface')
	$metadata_secret = hiera('metadata_secret')
	$tunnel_transfer = hiera('tunnel_transfer')
	$local_ip = inline_template("<%= scope.lookupvar('::ipaddress_${tunnel_transfer}') -%>")


	sysctl::value { "net.ipv4.ip_forward": value => "1"}
	sysctl::value { "net.ipv4.conf.all.rp_filter": value => "0"}
	sysctl::value { "net.ipv4.conf.default.rp_filter": value => "0"}

	$enhancers = [ "openstack-neutron", "openstack-neutron-ml2", "openstack-neutron-openvswitch" ]
	package { $enhancers: ensure => "installed" }

	file { 'neutron.conf':
        	path    => '/etc/neutron/neutron.conf',
        	ensure    => present,
        	owner     => 'root',
        	group     => 'root',
        	mode     => '0644',
        	content   => template("myneutron/neutron.erb"),
        }

        file { 'ml2_conf.ini':
                path    => '/etc/neutron/plugins/ml2/ml2_conf.ini',
                ensure    => present,
                owner     => 'root',
                group     => 'root',
                mode     => '0644',
                content   => template("myneutron/ml2_conf.ini.erb"),
        }

        file { 'l3_agent.ini':
                path    => '/etc/neutron/l3_agent.ini',
                ensure    => present,
                owner     => 'root',
               	group     => 'root',
                mode     => '0644',
                content   => template("myneutron/l3_agent.ini.erb"),
        }

        file { 'dhcp_agent.ini':
                path    => '/etc/neutron/dhcp_agent.ini',
                ensure    => present,
                owner     => 'root',
                group     => 'root',
                mode     => '0644',
                content   => template("myneutron/dhcp_agent.ini.erb"),
        }

        file { 'dnsmasq-neutron.conf':
                path    => '/etc/neutron/dnsmasq-neutron.conf',
                ensure    => present,
                owner     => 'root',
                group     => 'root',
                mode     => '0644',
                content   => template("myneutron/dnsmasq-neutron.erb"),
        }

	exec { "kill all dns masq process":
               command => "pkill dnsmasq",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
	}

        file { 'metadata_agent.ini':
                path    => '/etc/neutron/metadata_agent.ini',
                ensure    => present,
                owner     => 'root',
                group     => 'root',
                mode     => '0644',
                content   => template("myneutron/metadata_agent.erb"),
        }

        service { "openvswitch":
                ensure  => "running",
                enable  => "true",
        }

	exec { "Create bridge ex":
               command => "ovs-vsctl add-br br-ex",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
        }


	exec { "Add port":
               command => "ovs-vsctl add-port br-ex ${external_interface}",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
        }

	exec { "disable GRO":
               command => "ethtool -K ${external_interface} gro off",
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

        exec { "resolve OpenVS Issue":
                command => "cp /usr/lib/systemd/system/neutron-openvswitch-agent.service /usr/lib/systemd/system/neutron-openvswitch-agent.service.orig",
               	path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
        }

	exec { "resolve OpenVS Issue 2":
                command => "sed -i 's,plugins/openvswitch/ovs_neutron_plugin.ini,plugin.ini,g' /usr/lib/systemd/system/neutron-openvswitch-agent.service",
                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
        }

        service { "neutron-openvswitch-agent":
                ensure  => "running",
                enable  => "true",
        }

        service { "neutron-l3-agent":
                ensure  => "running",
                enable  => "true",
        }

        service { "neutron-dhcp-agent":
                ensure  => "running",
                enable  => "true",
        }

        service { "neutron-metadata-agent":
                ensure  => "running",
                enable  => "true",
        }

        service { "neutron-ovs-cleanup":
                ensure  => "running",
                enable  => "true",
        }

        file { 'ifcg-External':
                path    => "/etc/sysconfig/network-scripts/ifcfg-${external_interface}",
                ensure    => present,
                owner     => 'root',
                group     => 'root',
                mode     => '0644',
                content   => template("myneutron/ifcfg-interface"),
        }




#	exec { "make shared image dir":
#        	command => "mkdir -p ${glance_image_dir}",
#                path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
#	}

#        service { "rpcbind":
#                ensure  => "running",
#                enable  => "true",
#        }


#       file { 'glance-api.conf':
#        path    => '/etc/glance/glance-api.conf',
#        ensure    => present,
#        owner     => 'root',
#        group     => 'root',
#        mode	  => '0644',
#        content   => template("myglance/glance-api.erb"),
#        }



}



include myneutron
