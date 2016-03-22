notice('MODULAR: cinder_nfs.pp')


file { '/etc/cinder/nfsshares':
	ensure => 'present',
	content => '!HOST:SHARE!',
	owner => 'root',
	group => 'cinder',
	mode => '0640',
	}

