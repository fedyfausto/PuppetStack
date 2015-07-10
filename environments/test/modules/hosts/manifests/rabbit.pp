class hosts::rabbit ( $dns ) {
        $ip_array = hiera('rabbit_ips')
        $hst_array = hiera('rabbit_hosts')

        #host { "${hst_array}.${dns}":
        #	ip => $ip_array,
        #	host_aliases => $hst_array,
        #}


	$ip_array.each |Integer $index, String $value| {
                host { "${hst_array[$index]}.${dns}":
                        ip => $value,
                        host_aliases => "${hst_array[$index]}",
                }

        }
  
}

include hosts::rabbit
