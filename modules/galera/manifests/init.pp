class galera {
  include stdlib
  include apt 
  include galera::dependencies
  include galera::clusterconfig
  
      notice ('Sono dentro galera')
    
}


