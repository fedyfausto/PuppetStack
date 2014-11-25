node galera-master, default { 
  include puppet
  include hosts
}

node galera-1, galera-2, galera-3 {
  include puppet
  include hosts
}
