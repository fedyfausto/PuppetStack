  include ssh
  include puppet
  include hosts
  include user::virtual
  include sudoers
  include user::sysadmins
  include stdlib
  include apt

  include galera

node galera-master, default { 
  exec { "copy ssh keys":
    command => "cp /root/prisma/modules/ssh/files/* /root/.ssh",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }

  exec { "start galera cluster":
    command => "service mysql start --wsrep-new-cluster",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }  
}
node galera-1, galera-2, galera-3 {
  exec { "copy ssh auth_keys":
    command => "cp /root/prisma/modules/ssh/files/authorized_keys /root/.ssh",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }

  exec { "start galera cluster":
    command => "service mysql start",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }  
}
