class apt_inc {
  include apt
}
class galera {

  anchor { 'galera::begin': }                      ->
    class { 'apt_inc': }              -> 
    class { 'galera::dependencies': }              -> 
    class { 'galera::clusterconfig': }             -> 
  anchor { 'galera::end': }  
          
}


