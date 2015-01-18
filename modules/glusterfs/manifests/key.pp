class glusterfs::key {
      
  apt::source { 'glusterfs':
    location    => 'http://ppa.launchpad.net/gluster/glusterfs-3.6/ubuntu',
    release     => 'precise',
    repos       => 'main',
    key         => '4096R/3FE869A9',
    key_server  => 'keyserver.ubuntu.com',
    include_src => 'true',
    include_deb => 'true',
  }

}

include glusterfs::key
