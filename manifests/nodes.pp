include puppet
include ssh
include hosts
include user::virtual
include sudoers
include user::sysadmins
include stdlib

$galera_nodes = '4'

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
    priority => '100',
  }  
}

node haproxy-2 {
  class { 'haproxy':
    nodes_n  => $galera_nodes,
  }
  class { 'keepalived':
    priority => '101',
  }
}
