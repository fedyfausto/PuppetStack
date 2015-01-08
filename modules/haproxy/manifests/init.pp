include haproxy::key

class haproxy {
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
    source  => 'puppet:///modules/haproxy/haproxy.cfg',
    require => Package['haproxy'],
    notify  => Service['haproxy'],
  }
}
