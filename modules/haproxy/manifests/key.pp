class haproxy::key {
  include apt
      
  apt::source { 'mariadb':
    location    => 'http://mirror.jmu.edu/pub/mariadb/repo/5.5/ubuntu',
    release     => 'precise',
    repos       => 'main',
    key         => '0xcbcb082a1bb943db',
    key_server  => 'keyserver.ubuntu.com',
    include_src => 'true',
    include_deb => 'true',
  }

}

include haproxy::key
