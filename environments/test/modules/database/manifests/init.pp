class database {

  anchor { 'database::begin': } ->
    class { 'database::general': } ->
    class { 'database::haproxy': } ->
#    class { 'database::openstack': } ->
  anchor { 'database::end': }  

}

include database
