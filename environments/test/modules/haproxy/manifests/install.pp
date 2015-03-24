# nodes_n -> number of galera nodes

class haproxy::install ( $nodes_n ) {
  
  case $nodes_n {
    '3': {
      $hap_tem = 'haproxy.erb'
      $ip_gal_m = hiera('ip_gal_m')
      $ip_gal_1 = hiera('ip_gal_1')
      $ip_gal_2 = hiera('ip_gal_2')
      $hst_gal_m = hiera('hst_gal_m')
      $hst_gal_1 = hiera('hst_gal_1')
      $hst_gal_2 = hiera('hst_gal_2')
    }
    '4': {
      $hap_tem = 'haproxy4.erb'
      $ip_gal_m = hiera('ip_gal_m')
      $ip_gal_1 = hiera('ip_gal_1')
      $ip_gal_2 = hiera('ip_gal_2')
      $ip_gal_3 = hiera('ip_gal_3')
      $hst_gal_m = hiera('hst_gal_m')
      $hst_gal_1 = hiera('hst_gal_1')
      $hst_gal_2 = hiera('hst_gal_2')
      $hst_gal_3 = hiera('hst_gal_3')
    }
    '5': {
      $hap_tem = 'haproxy5.erb'
      $ip_gal_m = hiera('ip_gal_m')
      $ip_gal_1 = hiera('ip_gal_1')
      $ip_gal_2 = hiera('ip_gal_2')
      $ip_gal_3 = hiera('ip_gal_3')
      $ip_gal_4 = hiera('ip_gal_4')
      $hst_gal_m = hiera('hst_gal_m')
      $hst_gal_1 = hiera('hst_gal_1')
      $hst_gal_2 = hiera('hst_gal_2')
      $hst_gal_3 = hiera('hst_gal_3')
      $hst_gal_4 = hiera('hst_gal_4')
    }
  }
  case $osfamily {
    'Debian': {
      package { 'mariadb-client': ensure => installed }

      package { 'haproxy': 
        ensure  => installed ,
        require => Package["mariadb-client"],
      }

      file { '/etc/default/haproxy':
        content => "ENABLED=1\n",
        require => Package['haproxy'],
      }

      service { 'haproxy':
        ensure  => running,
        enable  => true,
        require => Package['haproxy'],
      }
  
      file { '/etc/haproxy/haproxy.cfg':
        path    => hiera('haproxy_cnf_path'),
        content => template("haproxy/${hap_tem}"),
        ensure  => present,
        require => Package['haproxy'],
        notify  => Service['haproxy'],
      }
    }
    'RedHat': {
    
### Uncomment if you choose MariaDB v5.5  ###  

#      package {'postfix':
#        ensure   => absent,
#        provider => yum,
#      }
      
#      package {'mariadb-libs':
#        ensure   => absent,
#        provider => yum,
#        require  => Package['postfix'],
#      }
        
      package {'MariaDB-client':
        ensure        => installed,
        allow_virtual => false,
        provider      => yum,
#        require       => Package['mariadb-libs'],
      }
      
      package { 'haproxy': 
        ensure        => installed,
        allow_virtual => false,
        provider      => yum,
        require       => Package['MariaDB-client'],
      }
      
      exec { 'enable':
        command => "systemctl enable haproxy.service",
        path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        require => Package['haproxy'],
      }
      
      service { 'haproxy':
        ensure   => running,
        provider => systemd,
        enable   => true,
        require  => Exec['enable'],
      }
  
      file { '/etc/haproxy/haproxy.cfg':
        path    => hiera('haproxy_cnf_path'),
        content => template("haproxy/${hap_tem}"),
        ensure  => present,
        require => Package['haproxy'],
        notify  => Service['haproxy'],
      }
      
      exec { 'config-file':
        command => 'haproxy -f /etc/haproxy/haproxy.cfg',
        path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        require => File['/etc/haproxy/haproxy.cfg'],
      }
      
      cron { 'workaround-haproxy':
        command => "/usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg",
        user    => root,
        special => 'reboot',
        require => Exec['config-file'],
      }
      
      
      ### Firewalld ###

      file { 'ha-firewall-cmd':
        ensure  => 'file',
        source  => 'puppet:///modules/haproxy/firewall-cmd.sh',
        path    => '/usr/local/bin/ha_firewall-cmd.sh',
        owner   => 'root',
        group   => 'root',
        mode    => '0744',
        notify  => Exec['ha-firewall-cmd'],
      }
      exec { 'ha-firewall-cmd':
        command     => '/usr/local/bin/ha_firewall-cmd.sh',
        refreshonly => true,
        notify      => Service['haproxy'],
      }
#      exec { 'restart haproxy':
#        command => 'systemctl restart haproxy.service',
#        path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
#        require => Exec['ha-firewall-cmd'],
#      }


      
#      file { 'haproxy.xml':
#        ensure  => 'file',
#        source  => 'puppet:///modules/haproxy/haproxy.xml',
#        path    => '/etc/firewalld/services/haproxy.xml',
#        owner   => 'root',
#        group   => 'root',
#        mode    => '0640',
#        require => Cron['workaround-haproxy'],
#      }
      
#      exec { 'restorecon':
#        command => 'restorecon /etc/firewalld/services/haproxy.xml',
#        path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
#        require => File['haproxy.xml'],
#      }
      
#      exec { 'add service':
#        command => 'firewall-cmd --permanent --zone=public --add-service=haproxy',
#        path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
#        require => Exec['restorecon'],
#      }
      
#      exec { 'reload firewall':
#        command => 'firewall-cmd --reload',
#        path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
#        require => Exec['add service'],
#      }
    }
  }
}

include haproxy::install
