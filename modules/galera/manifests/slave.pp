class galera::slave {

  include apt

  anchor { 'galera::begin': }                      ->
    class { 'galera::key': }                       -> 
    class { 'galera::dependencies': }              -> 
    class { 'galera::clusterconfig': }             -> 
    class { 'galera::exec::slave': }               -> 
  anchor { 'galera::end': }  
          
}

include galera::slave
