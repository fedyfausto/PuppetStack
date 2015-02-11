# To run twice, execute this before: killall -u rabbitmq
# To verify the claster status : rabbitmqctl cluster_status

class rabbit {

  $rabbit_nodes = hiera('rabbit_nodes')

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
        ensure => latest,
      }
    }
    'RedHat': {
      class { 'erlang': 
        epel_enable => true,
      }
    }
  }
  
  exec { 'clean':
    command => 'rm -rf /var/lib/rabbitmq/mnesia/*',
    path    => '/usr/local/bin/:/bin/:/sbin/:/usr/bin/',
  }

  class { 'rabbitmq':
    config_cluster           => true,
    cluster_nodes	     => $cluster_nodes,
#   cluster_node_type        => 'disk', #ram
    erlang_cookie            => 'A_SECRET_COOKIE_STRING',
    wipe_db_on_cookie_change => true,
    port                     => '5672',
    tcp_keepalive	     => true,
    require	             => Exec['clean'],
  }

}
