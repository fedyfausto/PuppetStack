class hosts {

  include hosts::galera
  include hosts::haproxy
  include hosts::rabbit
  include hosts::glusterfs  
}

include hosts
