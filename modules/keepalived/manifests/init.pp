# To test the vip assignation: sudo ip a | grep eth0

class keepalived 
  ($notification_email_from = hiera('notification_email_from'),
  $notification_email = hiera('notification_email'),
  $smtp_server = hiera('smtp_server'),
  $ka_password = hiera('ka_password'),
  $ip_hap_v = hiera('ip_hap_v'),
  $vip_interface = hiera('vip_interface')
){

  $keepalived_cnf_path = hiera('keepalived_cnf_path')  
  $hst_hap_1 = hiera('hst_hap_1')
  $hst_hap_2 = hiera('hst_hap_2')

  case $hostname {
    $hst_hap_1: {
      $priority = 100
    }
    $hst_hap_2: {
      $priority = 101
    }
  }

  package { 'keepalived': 
    ensure  => installed ,
  }

  file { '/etc/sysctl.conf':
    content => "net.ipv4.ip_nonlocal_bind = 1\n",
    require => Package['keepalived'],
  }

  exec { "sysctl":
    command => "sysctl -p",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    require => Package['keepalived'],
  }

  service { 'keepalived':
    ensure  => running,
    enable  => true,
    require => Exec['sysctl'],
  }

  file { 'keepalived.cfg':
    path    => $keepalived_cnf_path,
    content => template('keepalived/keepalived.erb'),
    ensure  => present,
    require => Package['keepalived'],
    notify  => Service['keepalived'],
  }

}

include keepalived
