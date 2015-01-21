class hosts::haproxy ( $dns ) {
  
  case hiera('haproxy_nodes') {
    '2': {
      $ip_hap_1 = hiera('ip_hap_1')
      $ip_hap_2 = hiera('ip_hap_2')
      $hst_hap_1 = hiera('hst_hap_1')  
      $hst_hap_2 = hiera('hst_hap_2')  
  
      host { "${hst_hap_1}.${dns}":
        ip => $ip_hap_1,
        host_aliases => $hst_hap_1,
      }

      host { "${hst_hap_2}.${dns}":
        ip => $ip_hap_2,
        host_aliases => $hst_hap_2,
      }
    }
    '3': {
      $ip_hap_1 = hiera('ip_hap_1')
      $ip_hap_2 = hiera('ip_hap_2')
      $ip_hap_3 = hiera('ip_hap_3')
      $hst_hap_1 = hiera('hst_hap_1')  
      $hst_hap_2 = hiera('hst_hap_2')  
      $hst_hap_3 = hiera('hst_hap_3')  

      host { "${hst_hap_1}.${dns}":
        ip => $ip_hap_1,
        host_aliases => $hst_hap_1,
      }

      host { "${hst_hap_2}.${dns}":
        ip => $ip_hap_2,
        host_aliases => $hst_hap_2,
      }

      host { "${hst_hap_3}.${dns}":
        ip => $ip_hap_3,
        host_aliases => $hst_hap_3,
      }
    }
  }
}

include hosts::haproxy
