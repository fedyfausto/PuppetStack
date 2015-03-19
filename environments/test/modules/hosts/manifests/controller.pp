class hosts::controller ( $dns ) {
  
  case hiera('controller_nodes') {
    '2': {
      $ip_con_1 = hiera('ip_con_1')
      $ip_con_2 = hiera('ip_con_2')
      $hst_con_1 = hiera('hst_con_1')  
      $hst_con_2 = hiera('hst_con_2')  
  
      host { "${hst_con_1}.${dns}":
        ip => $ip_con_1,
        host_aliases => $hst_con_1,
      }

      host { "${hst_con_2}.${dns}":
        ip => $ip_con_2,
        host_aliases => $hst_con_2,
      }
    }
    '3': {
      $ip_con_1 = hiera('ip_con_1')
      $ip_con_2 = hiera('ip_con_2')
      $ip_con_3 = hiera('ip_con_3')
      $hst_con_1 = hiera('hst_con_1')  
      $hst_con_2 = hiera('hst_con_2')  
      $hst_con_3 = hiera('hst_con_3')  
  
      host { "${hst_con_1}.${dns}":
        ip => $ip_con_1,
        host_aliases => $hst_con_1,
      }

      host { "${hst_con_2}.${dns}":
        ip => $ip_con_2,
        host_aliases => $hst_con_2,
      }

      host { "${hst_con_3}.${dns}":
        ip => $ip_con_3,
        host_aliases => $hst_con_3,
      }
    }
    '4': {
      $ip_con_1 = hiera('ip_con_1')
      $ip_con_2 = hiera('ip_con_2')
      $ip_con_3 = hiera('ip_con_3')
      $ip_con_4 = hiera('ip_con_4')
      $hst_con_1 = hiera('hst_con_1')  
      $hst_con_2 = hiera('hst_con_2')  
      $hst_con_3 = hiera('hst_con_3')  
      $hst_con_4 = hiera('hst_con_4')
  
      host { "${hst_con_1}.${dns}":
        ip => $ip_con_1,
        host_aliases => $hst_con_1,
      }

      host { "${hst_con_2}.${dns}":
        ip => $ip_con_2,
        host_aliases => $hst_con_2,
      }

      host { "${hst_con_3}.${dns}":
        ip => $ip_con_3,
        host_aliases => $hst_con_3,
      }
      
      host { "${hst_con_4}.${dns}":
        ip => $ip_con_4,
        host_aliases => $hst_con_4,
      }
    }
    '5': {
      $ip_con_1 = hiera('ip_con_1')
      $ip_con_2 = hiera('ip_con_2')
      $ip_con_3 = hiera('ip_con_3')
      $ip_con_4 = hiera('ip_con_4')
      $ip_con_5 = hiera('ip_con_5')
      $hst_con_1 = hiera('hst_con_1')  
      $hst_con_2 = hiera('hst_con_2')  
      $hst_con_3 = hiera('hst_con_3')  
      $hst_con_4 = hiera('hst_con_4')
      $hst_con_5 = hiera('hst_con_5')
  
      host { "${hst_con_1}.${dns}":
        ip => $ip_con_1,
        host_aliases => $hst_con_1,
      }

      host { "${hst_con_2}.${dns}":
        ip => $ip_con_2,
        host_aliases => $hst_con_2,
      }

      host { "${hst_con_3}.${dns}":
        ip => $ip_con_3,
        host_aliases => $hst_con_3,
      }
      
      host { "${hst_con_4}.${dns}":
        ip => $ip_con_4,
        host_aliases => $hst_con_4,
      }
      
      host { "${hst_con_5}.${dns}":
        ip => $ip_con_5,
        host_aliases => $hst_con_5,
      }
    }
  }  
}

include hosts::controller
