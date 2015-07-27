class galera::clusterconfig {
  
  #$collation_server = hiera('collation_server')
  #$init_connect = hiera('collation_server')
  #$character_set_server = hiera('character_set_server')
   
  $galera_ips = hiera('galera_ips')


  service { 'mysql':
    enable  => true,
    ensure  => stopped,
  }
  
  case $osfamily {
    'Debian': { 
      file { 'cluster.cnf':
        path    => hiera('cluster_cnf_path'),
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("galera/deb_cluster.erb"),
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
    'RedHat': {
      if $architecture == "x86_64" {
        $if64 = "64"
      } else {
        $if64 = ""
      }
      file { 'server.cnf':
        path    => hiera('cluster_cnf_path2'),
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("galera/red_cluster.erb"),
      }      
    }
  
  }
}
