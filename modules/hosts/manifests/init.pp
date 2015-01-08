class hosts {

  $ip_gal_m = hiera('ip_gal_m')
  $ip_gal_1 = hiera('ip_gal_1')
  $ip_gal_2 = hiera('ip_gal_2')

  host { 'galera-master':
    ip => $ip_gal_m,
    host_aliases => 'galera-master',
  }

  host { 'galera-1':
    ip => $ip_gal_1,
    host_aliases => 'galera-1',
  }

  host { 'galera-2':
    ip => $ip_gal_2,
    host_aliases => 'galera-2',
  }

}

include hosts
