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
node default {

}
