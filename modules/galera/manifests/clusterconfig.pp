class galera::clusterconfig ( $nodes_n ) {

  case $nodes_n {
    '3':{
      $erb = 'cluster.erb'  
      $ip1 = hiera('ip_gal_m')
      $ip2 = hiera('ip_gal_1')
      $ip3 = hiera('ip_gal_2')
    }
    '4':{
      $erb = 'cluster4.erb'  
      $ip1 = hiera('ip_gal_m')
      $ip2 = hiera('ip_gal_1')
      $ip3 = hiera('ip_gal_2')
      $ip4 = hiera('ip_gal_3')
    }
    '5':{
      $erb = 'cluster5.erb'  
      $ip1 = hiera('ip_gal_m')
      $ip2 = hiera('ip_gal_1')
      $ip3 = hiera('ip_gal_2')
      $ip4 = hiera('ip_gal_3')
      $ip5 = hiera('ip_gal_4')
    }
  }

  service { 'mysql':
    enable  => true,
    ensure  => stopped,
  }

  file { 'cluster.cnf':
    path    => hiera('cluster_cnf_path'),
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("galera/${erb}"),
  }

  file { 'debian.cnf':
    path    => hiera('debian_cnf_path'),
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('galera/debian.cnf'),
  }

}


