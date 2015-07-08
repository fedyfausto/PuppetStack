# Install Keystone
class mykeystone {
	class { 'keystone':
		log_verbose  => true,
		log_debug    => true,
		catalog_type => 'sql',
		admin_token  => 'pippo',
	} 
}
