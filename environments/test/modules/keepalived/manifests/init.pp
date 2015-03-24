# To test the vip assignation: sudo ip a | grep eth0

class keepalived ($haproxy_nodes) {
 
  $notification_email_from = hiera('notification_email_from')
  $notification_email = hiera('notification_email')
  $smtp_server = hiera('smtp_server')
  $ka_password = hiera('ka_password')
  $ip_hap_v = hiera('ip_hap_v')
  $vip_interface = hiera('vip_interface')
  $keepalived_cnf_path = hiera('keepalived_cnf_path')  

  case $haproxy_nodes {
    '2': {
      case $hostname {
        hiera('hst_hap_1'): {
          $priority = hiera('hap1_priority')
        }
        hiera('hst_hap_2'): {
          $priority = hiera('hap2_priority')
        }
      }
    }
    '3': {
      case $hostname {
        hiera('hst_hap_1'): {
          $priority = hiera('hap1_priority')
        }
        hiera('hst_hap_2'): {
          $priority = hiera('hap2_priority')
        }
        hiera('hst_hap_3'): {
          $priority = hiera('hap3_priority')
        }
      }  
    }
  }

  package { 'keepalived': 
    ensure        => installed ,
    allow_virtual => false,
    provider      => yum,
  }

  file { '/etc/sysctl.conf':
    content => "net.ipv4.ip_nonlocal_bind = 1\n",
    require => Package['keepalived'],
  }

  exec { "sysctl":
    command => "sysctl -p",
    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    require => Package['keepalived'],
  }

  service { 'keepalived':
    ensure   => running,
    enable   => true,
    provider => systemd,
    require  => Exec['sysctl'],
  }

  file { 'keepalived.cfg':
    path    => $keepalived_cnf_path,
    content => template('keepalived/keepalived.erb'),
    ensure  => present,
    require => Package['keepalived'],
    notify  => Service['keepalived'],
  }
  
  if $osfamily == "RedHat" {
#    service { 'firewalld':
#      provider => systemd,
#      enable   => true,
#      ensure   => running,
#    }
    file { 'firewall-cmd':
      ensure  => 'file',
      source  => 'puppet:///modules/keepalived/firewall-cmd.sh',
      path    => '/usr/local/bin/ka_firewall-cmd.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
      notify  => Exec['firewall-cmd'],
    }
    exec { 'firewall-cmd':
      command     => '/usr/local/bin/ka_firewall-cmd.sh',
      refreshonly => true,
      notify      => Service['keepalived'],
    }
#    exec { 'restart keepalived':
#      command => 'systemctl restart keepalived.service',
#      path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
#      require => Exec['firewall-cmd'],
#    }
    
  }

}

include keepalived
