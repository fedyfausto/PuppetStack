class hosts {

  $ip_gal_m = hiera('ip_gal_m')
  $ip_gal_1 = hiera('ip_gal_1')
  $ip_gal_2 = hiera('ip_gal_2')
  $ip_hap_1 = hiera('ip_hap_1')
  $ip_hap_2 = hiera('ip_hap_2')
  $ip_rab_1 = hiera('ip_rab_1')  
  $ip_rab_2 = hiera('ip_rab_2')
  $ip_rab_3 = hiera('ip_rab_3')

  $hst_gal_m = hiera('hst_gal_m')  
  $hst_gal_1 = hiera('hst_gal_1')  
  $hst_gal_2 = hiera('hst_gal_2')  
  $hst_hap_1 = hiera('hst_hap_1')  
  $hst_hap_2 = hiera('hst_hap_2')  
  $hst_rab_1 = hiera('hst_rab_1')  
  $hst_rab_2 = hiera('hst_rab_2')  
  $hst_rab_3 = hiera('hst_rab_3')  
  
  #$ip_pup_m = hiera('ip_pup_m')
  #host { 'puppet':
  #  ip => $ip_pup_m,
  #  host_aliases => 'puppet',
  #}
  
  host { $hst_gal_m:
    ip => $ip_gal_m,
    host_aliases => $hst_gal_m,
  }

  host { $hst_gal_1:
    ip => $ip_gal_1,
    host_aliases => $hst_gal_1,
  }

  host { $hst_gal_2:
    ip => $ip_gal_2,
    host_aliases => $hst_gal_2,
  }

  host { $hst_hap_1:
    ip => $ip_hap_1,
    host_aliases => $hst_hap_1,
  }

  host { $hst_hap_2:
    ip => $ip_hap_2,
    host_aliases => $hst_hap_2,
  }

  host { $hst_rab_1:
    ip => $ip_rab_1,
    host_aliases => $hst_rab_1,
  }

  host { $hst_rab_2:
    ip => $ip_rab_2,
    host_aliases => $hst_rab_1,
  }

  host { $hst_rab_3:
    ip => $ip_rab_3,
    host_aliases => $hst_rab_1,
  }
    
}

include hosts
