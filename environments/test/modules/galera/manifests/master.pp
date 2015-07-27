class galera::master {

  anchor { 'galera::begin': }                			        ->
    class { 'galera::key': }                       			-> 
    class { 'galera::dependencies': }             		        -> 
    class { 'galera::clusterconfig':}                                   -> 
    class { 'galera::exec::master': }              			-> 
  anchor { 'galera::end': }  
          
}

include galera::master
