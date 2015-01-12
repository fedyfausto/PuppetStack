include puppet
include ssh
include hosts
include user::virtual
include sudoers
include user::sysadmins
include stdlib

node galera-master {
  include galera::master
}

node galera-1, galera-2 {
  include galera::slave
}

node haproxy-1 {
  class { 'haproxy':
    nodes_n  => '3',
  }
  class { 'keepalived':
    priority => '100',
  }  
}

node haproxy-2 {
  class { 'haproxy':
    nodes_n  => '3',
  }
  class { 'keepalived':
    priority => '101',
  }
}
