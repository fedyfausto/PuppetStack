class hosts::haproxy ( $dns ) {
  
        $ip_array = hiera('haproxy_ips')
        $hst_array = hiera('haproxy_hosts')

	$ip_array.each |Integer $index, String $value| {
                host { "${hst_array[$index]}.${dns}":
                        ip => $value,
                        host_aliases => "${hst_array[$index]}",
                }

        }
}

include hosts::haproxy
