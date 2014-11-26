include ssh
include puppet
include hosts
include user::virtual
include user::sysadmins
include sudoers

node galera-master, default { 
}

node galera-1, galera-2, galera-3 {
}
