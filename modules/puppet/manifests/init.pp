class puppet { 

  $project_home = hiera('project_home')
  $puppet_conf = hiera('puppet_conf_path')

  file { '/usr/local/bin/papply': 
    source => 'puppet:///modules/puppet/papply.sh', 
    mode => '0755',
  }

  file { $puppet_conf:
    path    => $puppet_conf,
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('puppet/puppet.conf'),
  }

  service { 'puppet':
    ensure => running,
  }

  exec { 'remove-warning':
    command => "sed -i \'/templatedir*/d\' ${puppet_conf}",
    path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
    notify  => Service['puppet'],
  }

}

include puppet
