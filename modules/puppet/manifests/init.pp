class puppet { 
  file { '/usr/local/bin/papply': 
    source => 'puppet:///modules/puppet/papply.sh', 
    mode => '0755',
  }

  file { '/etc/puppet/puppet.conf':
    path => '/etc/puppet/puppet.conf',
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('puppet/puppet.conf'),
  }

  service { 'puppet':
    ensure => running,
  }

  exec { 'remove-warning':
    command => 'sed -i \'/templatedir*/d\' /etc/puppet/puppet.conf',
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    notify  => Service['puppet'],
  }

  exec { 'update stdlib':
    command => 'puppet module upgrade puppetlabs-stdlib --modulepath /root/prisma/modules',
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }

  exec { 'update apt':
    command => 'puppet module upgrade puppetlabs-apt --modulepath /root/prisma/modules',
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
  }

}
