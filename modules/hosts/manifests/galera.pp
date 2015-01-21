class hosts::galera {
  $dns = hiera('dns')
  
  case hiera('galera_nodes') {
    '3': {
      $ip_gal_m = hiera('ip_gal_m')
      $ip_gal_1 = hiera('ip_gal_1')
      $ip_gal_2 = hiera('ip_gal_2')
      $hst_gal_m = hiera('hst_gal_m')  
      $hst_gal_1 = hiera('hst_gal_1')  
      $hst_gal_2 = hiera('hst_gal_2')  
  
      host { "${hst_gal_m}.${dns}":
        ip => $ip_gal_m,
        host_aliases => $hst_gal_m,
      }

      host { "${hst_gal_1}.${dns}":
        ip => $ip_gal_1,
        host_aliases => $hst_gal_1,
      }

      host { "${hst_gal_2}.${dns}":
        ip => $ip_gal_2,
        host_aliases => $hst_gal_2,
      }
    }
    '4': {
      $ip_gal_m = hiera('ip_gal_m')
      $ip_gal_1 = hiera('ip_gal_1')
      $ip_gal_2 = hiera('ip_gal_2')
      $ip_gal_3 = hiera('ip_gal_3')
      $hst_gal_m = hiera('hst_gal_m')  
      $hst_gal_1 = hiera('hst_gal_1')  
      $hst_gal_2 = hiera('hst_gal_2')  
      $hst_gal_3 = hiera('hst_gal_3')  

      host { "${hst_gal_m}.${dns}":
        ip => $ip_gal_m,
        host_aliases => $hst_gal_m,
      }

      host { "${hst_gal_1}.${dns}":
        ip => $ip_gal_1,
        host_aliases => $hst_gal_1,
      }

      host { "${hst_gal_2}.${dns}":
        ip => $ip_gal_2,
        host_aliases => $hst_gal_2,
      }

      host { "${hst_gal_3}.${dns}":
        ip => $ip_gal_3,
        host_aliases => $hst_gal_3,
      }
    }
    '5': {
      $ip_gal_m = hiera('ip_gal_m')
      $ip_gal_1 = hiera('ip_gal_1')
      $ip_gal_2 = hiera('ip_gal_2')
      $ip_gal_3 = hiera('ip_gal_3')
      $ip_gal_4 = hiera('ip_gal_4')
      $hst_gal_m = hiera('hst_gal_m')  
      $hst_gal_1 = hiera('hst_gal_1')  
      $hst_gal_2 = hiera('hst_gal_2')  
      $hst_gal_3 = hiera('hst_gal_3')  
      $hst_gal_4 = hiera('hst_gal_4')  
      
      host { "${hst_gal_m}.${dns}":
        ip => $ip_gal_m,
        host_aliases => $hst_gal_m,
      }

      host { "${hst_gal_1}.${dns}":
        ip => $ip_gal_1,
        host_aliases => $hst_gal_1,
      }

      host { "${hst_gal_2}.${dns}":
        ip => $ip_gal_2,
        host_aliases => $hst_gal_2,
      }

      host { "${hst_gal_3}.${dns}":
        ip => $ip_gal_3,
        host_aliases => $hst_gal_3,
      }
      
      host { "${hst_gal_4}.${dns}":
        ip => $ip_gal_4,
        host_aliases => $hst_gal_4,
      }
    }
  }  
}

include hosts::galera
