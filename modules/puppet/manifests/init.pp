class puppet { 
  file { '/usr/local/bin/papply': 
    source => 'puppet:///modules/puppet/papply.sh', 
    mode => '0755',
  }

  service { 'puppet':
    ensure => running,
  }

  exec { 'remove-warning':
    command => 'sed -i \'/templatedir*/d\' /etc/puppet/puppet.conf',
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    notify  => Service['puppet'],
  }

  exec { 'install stdlib':
    command => 'puppet module install puppetlabs-stdlib',
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }

  exec { 'install apt':
    command => 'puppet module install puppetlabs-apt',
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }

}
