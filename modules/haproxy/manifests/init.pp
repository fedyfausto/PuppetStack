class haproxy ( $nodes_n ) {

  include apt

  anchor { 'haproxy::begin': }                             ->
    class { 'haproxy::key': }                              -> 
    class { 'haproxy::install': nodes_n => $nodes_n }      -> 
  anchor { 'haproxy::end': }  
          
}

include haproxy


## To Test The Load Balancer:
## mysql -uhaproxy_root -ppassword -h127.0.0.1 -e "show variables like 'wsrep_node_name' ;"
