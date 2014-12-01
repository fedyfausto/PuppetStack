include ssh
include puppet
include hosts
include user::virtual
include sudoers
include user::sysadmins

node galera-master, default { 
  exec { "copy ssh keys":
    command => "cp /root/prisma/modules/ssh/files/.ssh/* /root/.ssh",
    path    => "/usr/local/bin/:/bin/",
  }
}

node galera-1, galera-2, galera-3 {
}
