class galera {

#  contain stdlib
#  contain apt

  anchor { 'galera::begin': }                      ->
    class { 'galera::dependencies': }              -> 
    class { 'galera::clusterconfig': }             -> 
  anchor { 'galera::end': }  
      
notice ('Sono dentro galera')
    
}


