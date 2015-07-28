class disablefirewall {

  # Only run on systems known to have firewalld
  case $::osfamily {
    'RedHat' : {
        service { 'firewalld':
          ensure  => 'stopped',
          enable  => false,
	}      
    } # end RedHat
        
  } # end case $::osfamily
}
