# To run twice, execute this before: killall -u rabbitmq
# To verify the claster status : rabbitmqctl cluster_status

class rabbit {

#  Package { allow_virtual => false }

  $rabbit_nodes = hiera('rabbit_nodes')
  $hostname=$hostname

  case $rabbit_nodes {
    '3': {
      $cluster_nodes = [hiera('hst_rab_1'), hiera('hst_rab_2'), hiera('hst_rab_3')]
    }
    '4': {
      $cluster_nodes = [hiera('hst_rab_1'), hiera('hst_rab_2'), hiera('hst_rab_3'), hiera('hst_rab_4')]
    }
    '5': {
      $cluster_nodes = [hiera('hst_rab_1'), hiera('hst_rab_2'), hiera('hst_rab_3'), hiera('hst_rab_4'), hiera('hst_rab_5')]
    }
  }
  case $osfamily {
    'Debian': {
      include erlang
      package { 'erlang-base':
        ensure        => latest,
        allow_virtual => false,
      }
      
      exec { 'clean':
        command => 'rm -rf /var/lib/rabbitmq/mnesia/*',
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",
      }
    
      class { 'rabbitmq':
        config_cluster           => true,
        cluster_nodes	           => $cluster_nodes,
    #   cluster_node_type        => 'disk', #ram
        erlang_cookie            => 'A_SECRET_COOKIE_STRING',
        wipe_db_on_cookie_change => true,
        port                     => '5672',
        tcp_keepalive	           => true,
        require	                 => Exec['clean'],
      }
    }
    'RedHat': {
    
      ### Firewalld ###

      file { 'ra-firewall-cmd':
        ensure  => 'file',
        source  => 'puppet:///modules/rabbit/firewall-cmd.sh',
        path    => '/usr/local/bin/ra_firewall-cmd.sh',
        owner   => 'root',
        group   => 'root',
        mode    => '0744',
        notify  => Exec['ra-firewall-cmd'],
      }
      exec { 'ra-firewall-cmd':
        command     => '/usr/local/bin/ra_firewall-cmd.sh',
        refreshonly => true,
      }
    
      class { 'erlang': 
        epel_enable => true,
      }
      
      exec { 'clean':
        command => 'rm -rf /var/lib/rabbitmq/mnesia/*',
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/:/usr/sbin/",
        require => Exec['ra-firewall-cmd'],
      }
    
      class { 'rabbitmq':
        config_cluster           => true,
        cluster_nodes	           => $cluster_nodes,
    #   cluster_node_type        => 'disk', #ram
        erlang_cookie            => 'A_SECRET_COOKIE_STRING',
        wipe_db_on_cookie_change => true,
        port                     => '5672',
        tcp_keepalive	           => true,
        require	                 => Exec['clean'],
        package_provider         => 'yum',
        node_ip_address          => '127.0.0.1',
        environment_variables   => {
             'NODENAME'     => "rabbit@${hostname}",
        }
 
     }
      
    }
  }
  


}
