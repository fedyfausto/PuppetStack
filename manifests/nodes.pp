include puppet
include ssh
include hosts
include user::virtual
include sudoers
include user::sysadmins
include stdlib

$galera_nodes = hiera('galera_nodes')
$hap1_priority = hiera('hap1_priority')
$hap2_priority = hiera('hap2_priority')

node galera-master {
  class { 'galera::master':
    nodes_n => $galera_nodes,
  }
}

node /(galera-)+[0-9]/ {
  class { 'galera::slave':
    nodes_n => $galera_nodes,
  }
}

node haproxy-1 {
  class { 'haproxy':
    nodes_n  => $galera_nodes,
  }
  class { 'keepalived':
    priority => $hap1_priority,
  }  
}

node haproxy-2 {
  class { 'haproxy':
    nodes_n  => $galera_nodes,
  }
  class { 'keepalived':
    priority => $hap2_priority,
  }
}

node /(rabbit-)+[0-9]/ {
  include rabbit    
}
