class hosts::galera ( $dns ) {
        $ip_array = hiera('galera_ips')
        $hst_array = hiera('galera_hosts')


	$ip_array.each |Integer $index, String $value| {
                host { "${hst_array[$index]}.${dns}":
                        ip => $value,
                        host_aliases => "${hst_array[$index]}",
                }

        }

}

include hosts::galera
