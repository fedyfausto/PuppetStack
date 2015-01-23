class csync {

  package { 'haveged':
    ensure => installed,
  }

  service { 'haveged':
    ensure  => running,
    require => Package['haveged'],
  }

  class { 'corosync':
    enable_secauth    => true,
    authkey => '/var/lib/puppet/ssl/certs/ca.pem',
    bind_address      => hiera('net_ip'),
    multicast_address => hiera('net_mcast'),
    port              => hiera('mcast_port'),
    packages          => ['corosync', 'pacemaker'],
   }

  corosync::service { 'pacemaker':
    version => '1',
    notify  => Service['corosync'],
  }

  cs_property { 'stonith-enabled' :
    value   => 'false',
  }
  
 
}
