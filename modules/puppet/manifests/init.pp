class puppet { 

  include hosts

  $project_home = hiera('project_home')
  $puppet_conf = hiera('puppet_conf_path')
  $puppet_confdir = hiera('puppet_confdir')  
  $dns = hiera('dns')

  file { '/usr/local/bin/papply': 
    source => 'puppet:///modules/puppet/papply.sh', 
    mode   => '0755',
  }
  
  if $osfamily == "RedHat" {
    service { 'firewalld':
      provider => systemd,
      enable   => true,
      ensure   => running,
    }
    file { 'firewall-cmd':
      ensure  => 'file',
      source  => 'puppet:///modules/puppet/firewall-cmd.sh',
      path    => '/usr/local/bin/pm_firewall-cmd.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
      notify  => Exec['firewall-cmd'],
    }
    exec { 'firewall-cmd':
      command     => '/usr/local/bin/pm_firewall-cmd.sh',
      refreshonly => true,
    }
  }

#
# Puppet Master
#
  if ($hostname == 'puppet'){

    # include puppet::repo
    class {'puppet::repo':}

    file { $puppet_conf:
      path    => $puppet_conf,
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('puppet/puppetm.erb'),
      require => Class['puppet::repo'],
    }

    file { "${puppet_confdir}/autosign.conf":
      path    => "${puppet_confdir}/autosign.conf",
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('puppet/autosign.erb'),
      require => Class['puppet::repo'],
    }

    package { 'ntp': 
      ensure        => installed ,
      allow_virtual => false,
    }  
    service { 'ntp':
      ensure   => running,
      enable   => true,
     # provider => systemd,
    }

    # Puppet Master Certificate
    exec { 'get the cert':
      command => "puppet cert --generate ${hostname}.${dns}",
      path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      require => Class['puppet::repo'],
    }

    class {'passenger':
      passenger_provider     => 'gem',
      passenger_package      => 'passenger',
      gem_path               => '/var/lib/gems/1.8/gems',
      gem_binary_path        => '/var/lib/gems/1.8/bin',
      passenger_root         => '/var/lib/gems/1.8/gems/passenger-2.2.11'
      mod_passenger_location => '/var/lib/gems/1.8/gems/passenger-2.2.11/ext/apache2/mod_passenger.so',
      include_build_tools    => true,
    }
    
  }
#
# Puppet Agent
#
  else {
    file { $puppet_conf:
      path    => $puppet_conf,
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('puppet/puppet.erb'),
    }
    service { 'puppet':
      ensure => running,
    }      
  }
  



  if $osfamily == "Debian" {
    exec { 'remove-warning':
      command => "sed -i \'/templatedir*/d\' ${puppet_conf}",
      path    => "/usr/local/bin/:/bin/:/sbin/:/usr/bin/",
      notify  => Service['puppet'],
    }
  }

}

include puppet
