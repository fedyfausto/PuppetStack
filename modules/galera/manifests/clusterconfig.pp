class galera::clusterconfig
  ($ip1 = hiera('ip_gal_m'),
  $ip2 = hiera('ip_gal_1'),
  $ip3 = hiera('ip_gal_2')) {
  
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
    content => template('galera/cluster.erb'),
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


