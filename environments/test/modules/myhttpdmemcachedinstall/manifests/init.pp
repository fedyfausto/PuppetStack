# Install Apachi and memcached
class myhttpdmemcachedinstall {
      	
        $enhancers = [ "httpd", "mod_wsgi", "memcached", "python-memcached" ]
	package { $enhancers: ensure => "installed" }


	service { "memcached":
    		ensure  => "running",
    		enable  => "true",
	}

        service { "httpd":
                ensure  => "running",
                enable  => "true",
        }


}

include myhttpdmemcachedinstall
