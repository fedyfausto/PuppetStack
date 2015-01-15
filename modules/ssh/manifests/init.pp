class ssh {

  anchor { 'ssh::begin': }              ->
    class { 'ssh::install': }           -> 
    class { 'ssh::exec': }              -> 
  anchor { 'ssh::end': }  
  
}

include ssh
