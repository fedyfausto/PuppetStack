class hosts {

  $dns = hiera('dns')
  $hst_puppet = hiera('hst_puppet')
  $ip_puppet = hiera('ip_puppet')
  
  host { "${hst_puppet}.${dns}":
    ip => $ip_puppet,
    host_aliases => $hst_puppet,
  }

  class {'hosts::galera':
    dns => $dns,
  }

  class {'hosts::haproxy':
    dns => $dns,
  }

  class {'hosts::rabbit':
    dns => $dns,
  }

  class {'hosts::glusterfs':
    dns => $dns,
  }
  
  class {'hosts::controller':
    dns => $dns,
  }
}

include hosts
