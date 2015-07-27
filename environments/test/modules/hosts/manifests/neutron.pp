class hosts::neutron ( $dns ) {

	$ip_array = hiera('neutron_ips')
	$hst_array = hiera('neutron_hosts')

	#host { "${hst_array}.${dns}":
        #	ip => $ip_array,
        #	host_aliases => $hst_array,
      	#}


	$ip_array.each |Integer $index, String $value| { 
		notify{"PPP - ${hst_array[$index]}.${dns} - ${value} - ${index}" : }
		host { "${hst_array[$index]}.${dns}":
			ip => $value,
			host_aliases => "${hst_array[$index]}",
        	}

	}
}

include hosts::neutron
