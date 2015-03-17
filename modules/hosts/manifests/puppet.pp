class hosts::puppet ( $dns ) {
  
  #Puppet Agent node is for management only. Do not use it in normal environments!
  #Every node, except the Puppet Master node, is a Puppet Agent.

  $ip_puppet_m = hiera('ip_puppet_m')
  $ip_puppet_a = hiera('ip_puppet_a')
  $hst_puppet_m = hiera('hst_puppet_m')  
  $hst_puppet_a = hiera('hst_puppet_a')  
  
  host { "${hst_puppet_m}.${dns}":
    ip => $ip_puppet_m,
    host_aliases => $hst_puppet_m,
  }

  host { "${hst_puppet_a}.${dns}":
    ip => $ip_puppet_a,
    host_aliases => $hst_puppet_a,
  }
}

include hosts::puppet
