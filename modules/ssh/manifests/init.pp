class ssh {

  anchor { 'ssh::begin': }              ->
    class { 'ssh::install': }           -> 
    class { 'ssh::exec': }              -> 
  anchor { 'ssh::end': }  
  
  notice ( 'ssh init...complete!' )          
}

include ssh
