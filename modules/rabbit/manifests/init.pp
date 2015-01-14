# To run twice, execute this before: killall -u rabbitmq
# To verify the claster status : rabbitmqctl cluster_status

class rabbit {

  include erlang

  $hst_rab_1 = hiera('hst_rab_1')
  $hst_rab_2 = hiera('hst_rab_2')
  $hst_rab_3 = hiera('hst_rab_3')  

  package { 'erlang-base':
    ensure => latest,
  }
  
  exec { 'clean':
    command => 'rm -rf /var/lib/rabbitmq/mnesia/*',
    path    => '/usr/local/bin/:/bin/:/sbin/:/usr/bin/',
  }

  class { 'rabbitmq':
    config_cluster           => true,
    cluster_nodes            => [$hst_rab_1, $hst_rab_2, $hst_rab_3],
#    cluster_node_type        => 'disk', #ram
    erlang_cookie            => 'A_SECRET_COOKIE_STRING',
    wipe_db_on_cookie_change => true,
    port                     => '5672',
    tcp_keepalive	     => true,
    require	             => Exec['clean'],
  }

}
