####
#  Facter osfamily, lib.
#  https://www.omniref.com/ruby/gems/facter/1.7.1/files/lib/facter/osfamily.rb#line=14
####

class user::virtual {
  
  define ssh_user($key, $password = hiera('virt_usr_default_pwd'), $sshkeytype = "ssh-rsa") {
    if $name != 'root' {
      $homedir = $::osfamily ? {
        'Solaris' => '/export/home',
        'Debian'  => '/home',
        default   => '/home', 
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
#      notice("The password is: ${password}, the user is ${name}, the home is ${homedir}, the ssh_key is ${key}")
    } else {
      $homedir = '/root' 
      file { "${homedir}/.ssh": 
        ensure => directory,
        mode => '0755',
        owner => 'root', 
        group => 'root',
      }
      ssh_authorized_key { "root_key":
        key     => $key,
        type    => $sshkeytype,
        user    => 'root',
        ensure  => present,
        require => File["${homedir}/.ssh"],
      }
#      notice("The password is: ${password}, the user is ${name}, the home is ${homedir}, the ssh_key is ${key}")      
    }
  }
  @ssh_user { 'root':
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC7llqR567sYc9APpodBgKJu00Kv9S7tzVBJ3Y6q4exds5Af5kkSLlv1mbJCOHl13pKJxN2qs9SzB02dl6wibO4u+m2gEyE5NsDBWwCdWffZxIJelfFGlLId4ZQKjWjL4I5cm3aaWvTexxViL10EaONEJK19WUkAP+bZ+3iApxRmHotT5G7TvL0CYchTCLbnrbG8nV4vjEUrGq+f+rw0U9ijBS/9KuH1UKbnj0t2EFtPJhTQPAXP4uR7Vj++L6EIg3ZPsT/+CrYDXcPxmNI1VDCtMg5cwicWz9mq5l5UGXpR0fyW15zV/E9l+lY9QcpzlQUIfYEDLOor7Ky1wBRP1Ix',
  }
  
  @ssh_user { 'prisma':
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC7llqR567sYc9APpodBgKJu00Kv9S7tzVBJ3Y6q4exds5Af5kkSLlv1mbJCOHl13pKJxN2qs9SzB02dl6wibO4u+m2gEyE5NsDBWwCdWffZxIJelfFGlLId4ZQKjWjL4I5cm3aaWvTexxViL10EaONEJK19WUkAP+bZ+3iApxRmHotT5G7TvL0CYchTCLbnrbG8nV4vjEUrGq+f+rw0U9ijBS/9KuH1UKbnj0t2EFtPJhTQPAXP4uR7Vj++L6EIg3ZPsT/+CrYDXcPxmNI1VDCtMg5cwicWz9mq5l5UGXpR0fyW15zV/E9l+lY9QcpzlQUIfYEDLOor7Ky1wBRP1Ix',
    password => 'prisma',
  }
}
