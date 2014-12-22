class hosts {

  host { 'galera-master':
    ip => '10.55.1.150',
    host_aliases => 'galera-master',
  }

  host { 'galera-1':
    ip => '10.55.1.151',
    host_aliases => 'galera-1',
  }

  host { 'galera-2':
    ip => '10.55.1.152',
    host_aliases => 'galera-2',
  }

# host { 'galera-3':
#   ip => '10.55.1.153',
#   host_aliases => 'galera-3',
# }

}

include hosts
