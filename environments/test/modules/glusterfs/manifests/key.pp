class glusterfs::key {
      
  apt::source { 'glusterfs':
    location    => 'http://ppa.launchpad.net/gluster/glusterfs-3.6/ubuntu',
    release     => 'precise',
    repos       => 'main',
    key         => '0x13e01b7b3fe869a9',
    key_server  => 'keyserver.ubuntu.com',
    include_src => 'true',
    include_deb => 'true',
  }

}

include glusterfs::key
