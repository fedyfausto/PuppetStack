# Install NTP
class ntp {
      	
      package { 'ntp':
        ensure => installed,
      }


	service { "ntpd":
    		ensure  => "running",
    		enable  => "true",
	}

}

include ntp
