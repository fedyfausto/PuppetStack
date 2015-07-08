class hosts::controller ( $dns ) {

	$ip_array = hiera('controller_ips')
	$hst_array = hiera('controller_hosts')

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

include hosts::controller
