class user::virtual {
  define ssh_user($key, $password, $sshkeytype = "ssh-rsa") {
    $homedir = $kernel ? {
      'SunOS' => '/export/home',
      default => '/home', 
    }
    user { $name:     
      ensure     => present,
      managehome => true,
      password   => sha1($password),
    }
    file { "${homedir}/${name}/.ssh":
      ensure => directory,
      mode   => '0700',
      owner  => $name,
      group  => $name,
    }
    ssh_authorized_key { "${name}_key":
      key     => $key,
      type    => $sshkeytype,
      user    => $name,
      ensure  => present,
      require => File["${homedir}/${name}/.ssh"],
    }
    notice("The password is: ${password}, the user is ${name}, the home is ${homedir}, the ssh_key is ${key}")
  }

  @ssh_user { 'prisma':
    key      => 'pippo',
    password => 'prisma',
  }
}
