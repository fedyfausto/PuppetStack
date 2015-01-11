class hosts {

  $ip_gal_m = hiera('ip_gal_m')
  $ip_gal_1 = hiera('ip_gal_1')
  $ip_gal_2 = hiera('ip_gal_2')
  $ip_hap_1 = hiera('ip_hap_1')
  $ip_hap_2 = hiera('ip_hap_2')
  
  #$ip_pup_m = hiera('ip_pup_m')
  #host { 'puppet':
  #  ip => $ip_pup_m,
  #  host_aliases => 'puppet',
  #}
  
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

  host { 'haproxy-1':
    ip => $ip_hap_1,
    host_aliases => 'haproxy-1',
  }

  host { 'haproxy-2':
    ip => $ip_hap_2,
    host_aliases => 'haproxy-2',
  }

}

include hosts
