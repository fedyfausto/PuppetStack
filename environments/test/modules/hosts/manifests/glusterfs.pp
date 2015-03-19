class hosts::glusterfs ( $dns ) {
  
  case hiera('gluster_nodes') {
    '2': {
      $ip_glu_1 = hiera('ip_glu_1')
      $ip_glu_2 = hiera('ip_glu_2')
      $hst_glu_1 = hiera('hst_glu_1')  
      $hst_glu_2 = hiera('hst_glu_2')  

      host { "${hst_glu_1}.${dns}":
        ip => $ip_glu_1,
        host_aliases => $hst_glu_1,
      }

      host { "${hst_glu_2}.${dns}":
        ip => $ip_glu_2,
        host_aliases => $hst_glu_2,
      }
    }
    '3': {
      $ip_glu_1 = hiera('ip_glu_1')
      $ip_glu_2 = hiera('ip_glu_2')
      $ip_glu_3 = hiera('ip_glu_3')
      $hst_glu_1 = hiera('hst_glu_1')  
      $hst_glu_2 = hiera('hst_glu_2')  
      $hst_glu_3 = hiera('hst_glu_3')  
  
      host { "${hst_glu_1}.${dns}":
        ip => $ip_glu_1,
        host_aliases => $hst_glu_1,
      }

      host { "${hst_glu_2}.${dns}":
        ip => $ip_glu_2,
        host_aliases => $hst_glu_2,
      }

      host { "${hst_glu_3}.${dns}":
        ip => $ip_glu_3,
        host_aliases => $hst_glu_3,
      }
    }
    '4': {
      $ip_glu_1 = hiera('ip_glu_1')
      $ip_glu_2 = hiera('ip_glu_2')
      $ip_glu_3 = hiera('ip_glu_3')
      $ip_glu_4 = hiera('ip_glu_4')
      $hst_glu_1 = hiera('hst_glu_1')  
      $hst_glu_2 = hiera('hst_glu_2')  
      $hst_glu_3 = hiera('hst_glu_3')  
      $hst_glu_4 = hiera('hst_glu_4')
      
      host { "${hst_glu_1}.${dns}":
        ip => $ip_glu_1,
        host_aliases => $hst_glu_1,
      }

      host { "${hst_glu_2}.${dns}":
        ip => $ip_glu_2,
        host_aliases => $hst_glu_2,
      }

      host { "${hst_glu_3}.${dns}":
        ip => $ip_glu_3,
        host_aliases => $hst_glu_3,
      }
      
      host { "${hst_glu_4}.${dns}":
        ip => $ip_glu_4,
        host_aliases => $hst_glu_4,
      }
    }
    '5': {
      $ip_glu_1 = hiera('ip_glu_1')
      $ip_glu_2 = hiera('ip_glu_2')
      $ip_glu_3 = hiera('ip_glu_3')
      $ip_glu_4 = hiera('ip_glu_4')
      $ip_glu_5 = hiera('ip_glu_5')
      $hst_glu_1 = hiera('hst_glu_1')  
      $hst_glu_2 = hiera('hst_glu_2')  
      $hst_glu_3 = hiera('hst_glu_3')  
      $hst_glu_4 = hiera('hst_glu_4')
      $hst_glu_5 = hiera('hst_glu_5')
  
      host { "${hst_glu_1}.${dns}":
        ip => $ip_glu_1,
        host_aliases => $hst_glu_1,
      }

      host { "${hst_glu_2}.${dns}":
        ip => $ip_glu_2,
        host_aliases => $hst_glu_2,
      }

      host { "${hst_glu_3}.${dns}":
        ip => $ip_glu_3,
        host_aliases => $hst_glu_3,
      }
      
      host { "${hst_glu_4}.${dns}":
        ip => $ip_glu_4,
        host_aliases => $hst_glu_4,
      }
      
      host { "${hst_glu_5}.${dns}":
        ip => $ip_glu_5,
        host_aliases => $hst_glu_5,
      }
    }
  }  
}

include hosts::glusterfs
