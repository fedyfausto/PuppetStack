class galera::clusterconfig
  ($ip1 = '10.55.1.150',
  $ip2 = '10.55.1.151',
  $ip3 = '10.55.1.152',) {
  
  service { 'mysql':
    enable  => true,
    ensure  => stopped,
  }

  file { 'cluster.cnf':
    path    => '/etc/mysql/conf.d/cluster.cnf',
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('galera/cluster.erb'),
  }

  file { 'debian.cnf':
    path    => '/etc/mysql/debian.cnf',
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('galera/debian.cnf'),
  }

}


