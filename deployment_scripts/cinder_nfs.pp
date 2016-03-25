notice('MODULAR: cinder_nfs.pp')
$cinder_nfs = hiera('cinder_nfs', {})
$server_ip = pick($cinder_nfs['server_ip'], {})
$share_name = pick($cinder_nfs['share_name'], {})



file { '/etc/cinder':
	ensure => 'directory',
	}
file { '/etc/cinder/nfsshares':
	ensure => 'present',
	content => "$server_ip:$share_name",
	owner => 'root',
	group => 'cinder',
	mode => '0640',
	require => File['/etc/cinder'],
	}

