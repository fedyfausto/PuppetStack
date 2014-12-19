class galera {

  class apt_include {
    include apt
  }

  anchor { 'galera::begin': }                      ->
    class { 'apt_include': }                       ->
    class { 'galera::dependencies': }              -> 
    class { 'galera::clusterconfig': }             -> 
  anchor { 'galera::end': }  
      
notice ('Sono dentro galera')
    
}


