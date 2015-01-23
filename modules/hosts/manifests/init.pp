class hosts {

  $dns = hiera('dns')

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
