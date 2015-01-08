class haproxy {

  include apt

  anchor { 'haproxy::begin': }                      ->
    class { 'haproxy::key': }                       -> 
    class { 'haproxy::install': }                   -> 
  anchor { 'haproxy::end': }  
          
}

include haproxy
