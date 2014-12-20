class galera {

#  include apt

  anchor { 'galera::begin': }                      ->
    class { 'galera::dependencies': }              -> 
    class { 'galera::clusterconfig': }             -> 
  anchor { 'galera::end': }  
          
}

include galera
