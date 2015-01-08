class haproxy {

  include apt

  anchor { 'haproxy::begin': }                      ->
    class { 'haproxy::key': }                       -> 
    class { 'haproxy::install': }                   -> 
  anchor { 'haproxy::end': }  
          
}

include haproxy


## To Test The Load Balancer:
## mysql -uhaproxy_root -ppassword -h127.0.0.1 -e "show variables like 'wsrep_node_name' ;"
