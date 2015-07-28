#
# This module is useless due to puppet master architecture
# include ssh
# Hosts now included by puppet module
# include hosts
#

include puppet
include user::virtual
#include sudoers
#include user::sysadmins
include stdlib
require myselinux

$controllers = hiera('controller_hosts')
$computes = hiera('compute_hosts')
$galeras = hiera('galera_hosts')
$haproxies = hiera('haproxy_hosts')
$rabbits = hiera('rabbit_hosts')
$neutrons = hiera('neutron_hosts')

# To globally deny virtual packages
Package { allow_virtual => false }

node default { }

if ($hostname in $galeras) {
        if $hostname == $galeras[0]  {
		class { 'galera::master': }
        } else {
		class { 'galera::slave': }
	}
}

if ($hostname in $haproxies) {
  $haproxy_nodes = $haproxies.size
  class { 'haproxy': }
  class { 'keepalived': 
     haproxy_nodes =>  $haproxy_nodes,
  }

}

if ($hostname in $rabbits) {
	include rabbit
}



if ($hostname in $controllers) {
	class { 'ntp': }                                                
        class { 'galeraclient': }                                       
        class { 'openstackrepo': }                                      
        class { 'myhttpdmemcachedinstall': }                            
        class { 'mykeystone': }           	  	  	  	
        class { 'myglance': }                     	  	  	
        class { 'mycontrollernova': }                             	
        class { 'mycontrollerneutron': }                          	
        class { 'mydashboard': }                  	          	
}

if ($hostname in $computes) {
#	class { '::firewalld2iptables':  }

	class { 'ntp': }
        class { 'openstackrepo': }
        class { 'mynova': }

}

if ($hostname in $neutrons) {
        class { 'ntp': }
        class { 'openstackrepo': }
	class { 'myneutron': }
#	include ntp
#	include openstackrepo
#        include myneutron
}


node gluster-1 {
  include glusterfs::mainserver
}

node /(gluster-)+[2-9]/ {
  include glusterfs::server
}

node gluster-client {
  include glusterfs::client
}





# Test node
node puppet-agent {
  file { 'agent_test':
    ensure  => present,
    path    => '/root/AGENT_TEST',
    content => 'Puppet Master Working Yo! :-)',
  }
}
