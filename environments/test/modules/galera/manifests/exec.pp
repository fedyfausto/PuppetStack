class galera::exec::master {
  if $osfamily == "RedHat" {
    exec { "enforcing mode":
      command => "setenforce 0",
      path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
#      notify  => Service['firewalld'],
    }
#    service { 'firewalld':
#      provider => systemd,
#      enable   => true,
#      ensure   => running,
#    }
    file { 'firewall-cmd':
      ensure  => 'file',
      source  => 'puppet:///modules/galera/firewall-cmd.sh',
      path    => '/usr/local/bin/firewall-cmd.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
      notify  => Exec['firewall-cmd'],
    }
    exec { 'firewall-cmd':
      command     => '/usr/local/bin/firewall-cmd.sh',
      refreshonly => true,
    }
  }
	file { 'recovery_cluster':
      ensure  => 'file',
      source  => 'puppet:///modules/galera/recovery_cluster.sh',
      path    => '/root/recovery_cluster.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
    }
    
  exec { "set cronjob":
    command => 'croncmd="/bin/bash /root/recover_cluster.sh 1";cronjob="@reboot $croncmd";( crontab -l | grep -v "$croncmd" ; echo "$cronjob" ) | crontab -',
    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  }
   
  exec { "start galera cluster":
    command => "service mysql start --wsrep-new-cluster",
    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  }
  
  class { 'database':
    require => Exec["start galera cluster"],
  }
}

class galera::exec::slave {
  if $osfamily == "RedHat" {
    exec { "enforcing mode":
      command => "setenforce 0",
      path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
#      notify  => Service['firewalld'],
    }
#    service { 'firewalld':
#      enable   => true,
#      ensure   => running,
#      provider => systemd,
#    }
    file { 'firewall-cmd':
      ensure  => 'file',
      source  => 'puppet:///modules/galera/firewall-cmd.sh',
      path    => '/usr/local/bin/firewall-cmd.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
      notify  => Exec['firewall-cmd'],
    }
    exec { 'firewall-cmd':
      command     => '/usr/local/bin/firewall-cmd.sh',
      refreshonly => true,
    }
  }
  
	file { 'recovery_cluster':
      ensure  => 'file',
      source  => 'puppet:///modules/galera/recovery_cluster.sh',
      path    => '/root/recovery_cluster.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
    }
    
  exec { "set cronjob":
    command => 'croncmd="/bin/bash /root/recover_cluster.sh 0";cronjob="@reboot $croncmd";( crontab -l | grep -v "$croncmd" ; echo "$cronjob" ) | crontab -',
    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  }

  exec { "participate galera cluster":
    command => "service mysql start",
    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  }
} 


