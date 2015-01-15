class ssh::exec {

include ssh::params

#  case $hostname {
 
#    'galera-master': {
      exec { "copy ssh keys":
        command => "cp ${project_home}/modules/ssh/files/* /root/.ssh",
        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
      }
#    }  

#    'galera-1','galera-2': {
#      exec { "copy ssh auth_keys":
#        command => "cp ${project_home}/modules/ssh/files/authorized_keys /root/.ssh",
#        path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
#      }        
#    }

#  }
}

include ssh::exec
