class hosts::rabbit {
  
  case hiera('rabbit_nodes') {
    '3': {
      $ip_rab_1 = hiera('ip_rab_1')
      $ip_rab_2 = hiera('ip_rab_2')
      $ip_rab_3 = hiera('ip_rab_3')
      $hst_rab_1 = hiera('hst_rab_1')  
      $hst_rab_2 = hiera('hst_rab_2')  
      $hst_rab_3 = hiera('hst_rab_3')  
  
      host { $hst_rab_1:
        ip => $ip_rab_1,
        host_aliases => $hst_rab_1,
      }

      host { $hst_rab_2:
        ip => $ip_rab_2,
        host_aliases => $hst_rab_2,
      }

      host { $hst_rab_3:
        ip => $ip_rab_3,
        host_aliases => $hst_rab_3,
      }
    }
    '4': {
      $ip_rab_1 = hiera('ip_rab_1')
      $ip_rab_2 = hiera('ip_rab_2')
      $ip_rab_3 = hiera('ip_rab_3')
      $ip_rab_4 = hiera('ip_rab_4')
      $hst_rab_1 = hiera('hst_rab_1')  
      $hst_rab_2 = hiera('hst_rab_2')  
      $hst_rab_3 = hiera('hst_rab_3')  
      $hst_rab_4 = hiera('hst_rab_4')
      
      host { $hst_rab_1:
        ip => $ip_rab_1,
        host_aliases => $hst_rab_1,
      }

      host { $hst_rab_2:
        ip => $ip_rab_2,
        host_aliases => $hst_rab_2,
      }

      host { $hst_rab_3:
        ip => $ip_rab_3,
        host_aliases => $hst_rab_3,
      }
      
      host { $hst_rab_4:
        ip => $ip_rab_4,
        host_aliases => $hst_rab_4,
      }
    }
    '5': {
      $ip_rab_1 = hiera('ip_rab_1')
      $ip_rab_2 = hiera('ip_rab_2')
      $ip_rab_3 = hiera('ip_rab_3')
      $ip_rab_4 = hiera('ip_rab_4')
      $ip_rab_5 = hiera('ip_rab_5')
      $hst_rab_1 = hiera('hst_rab_1')  
      $hst_rab_2 = hiera('hst_rab_2')  
      $hst_rab_3 = hiera('hst_rab_3')  
      $hst_rab_4 = hiera('hst_rab_4')
      $hst_rab_5 = hiera('hst_rab_5')
  
      host { $hst_rab_1:
        ip => $ip_rab_1,
        host_aliases => $hst_rab_1,
      }

      host { $hst_rab_2:
        ip => $ip_rab_2,
        host_aliases => $hst_rab_2,
      }

      host { $hst_rab_3:
        ip => $ip_rab_3,
        host_aliases => $hst_rab_3,
      }
      
      host { $hst_rab_4:
        ip => $ip_rab_4,
        host_aliases => $hst_rab_4,
      }
      
      host { $hst_rab_5:
        ip => $ip_rab_5,
        host_aliases => $hst_rab_5,
      }
    }
  }  
}

include hosts::rabbit
