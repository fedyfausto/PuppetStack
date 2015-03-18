class puppet { 

  include hosts

  $project_home = hiera('project_home')
  $puppet_conf = hiera('puppet_conf_path')
  $puppet_confdir = hiera('puppet_confdir')  
  $dns = hiera('dns')
  $httpd_confpath = hiera('httpd_confpath')
  $puppetmasterd_path = hiera('puppetmasterd_path')
  $rack_path = hiera('rack_path')
  $passenger_inst_path = hiera('passenger_inst_path')
  $passenger_version = hiera('passenger_version')
  $ruby_bin_path = hiera('ruby_bin_path')

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

    # Puppet Master Certificate
    exec { 'get the cert':
      command => "puppet cert --generate ${hostname}.${dns}",
      path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      require => Class['puppet::repo'],
    }
    
    # Apache dependencies
    $apache_dep = [ "httpd", "httpd-devel", "mod_ssl", "ruby-devel", "rubygems", "gcc", "gcc-c++", "libcurl-devel", "openssl-devel", "zlib-devel" ]
    package { $apache_dep: ensure => "installed" }

    # Gem install rack passenger
    exec { 'gem install':
      command => "sudo gem install rack passenger:${passenger_version}",
      path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      require => Package[ $apache_dep ],
    }

    # Setup Apache Passenger
#    exec{ 'apache':
#      command => "yes '' | /usr/local/bin/passenger-install-apache2-module", 
#      path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
#      require => Exec[ 'gem install' ],
#    }

    file { 'apache.sh':
      ensure  => 'file',
      source  => 'puppet:///modules/puppet/apache.sh',
      path    => '/usr/local/bin/apache.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
      notify  => Exec['apache'],
    }
    exec { 'apache':
      command => '/usr/local/bin/apache.sh',
      require => Exec['gem install'],
    }


    # Directory tree
    $dir_tree = [ "${puppetmasterd_path}", "${puppetmasterd_path}/tmp","${puppetmasterd_path}/public" ]

    file { $dir_tree:
      ensure  => "directory",
      require => Exec['apache'],
    }

    file { 'config.ru':
      path    => "${puppetmasterd_path}/config.ru",
      source  => 'puppet:///modules/puppet/config.ru',
      owner   => 'puppet',
      group   => 'puppet',
      require => File[ $dir_tree ],
    }    

    # puppetmaster.conf
    file { 'puppetmaster.conf':
      path    => "${httpd_confpath}/puppetmaster.conf",
      ensure  => present,
      content => template('puppet/puppetmaster.erb'),
      require => File[ $dir_tree ],    
    }

    service { 'httpd':
      ensure  => running,
      enable  => true,
      require => File['puppetmaster.conf'],
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
