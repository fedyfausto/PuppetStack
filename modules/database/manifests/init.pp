class database {

  anchor { 'database::begin': } ->
    class { 'database::general': } ->
    class { 'database::haproxy': } ->
  anchor { 'database::end': }  

}

include database
