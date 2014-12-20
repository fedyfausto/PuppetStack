class galera {

  include apt

  anchor { 'galera::begin': }                      ->
    class { 'galera::key': }                       -> 
    class { 'galera::dependencies': }              -> 
    class { 'galera::clusterconfig': }             -> 
    class { 'galera::exec': }                      -> 
  anchor { 'galera::end': }  
          
}

include galera
