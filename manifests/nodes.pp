include puppet
include ssh
include hosts
include user::virtual
include sudoers
include user::sysadmins
include stdlib


node galera-master, galera-1, galera-2 {
  include galera
}

node haproxy-1, haproxy-2 {
  include haproxy
}

node default {
}
