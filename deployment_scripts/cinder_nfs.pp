notice('MODULAR: cinder_nfs.pp')
$cinder_nfs = hiera('cinder_nfs', {})
$server_ip = pick($cinder_nfs['server_ip'], {})
$share_name = pick($cinder_nfs['share_name'], {})
$cinder = [ 'cinder-api', 'cinder-scheduler']

service { $cinder:
	ensure => 'running',
}
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
file_line { 'enable_nfs':
	line => "nfs_shares_config = /etc/cinder/nfsshare",
	after => "[DEFAULT]",
	path => "/etc/cinder/cinder.conf",
	notify => Service[$cinder],
	}
file_line { 'cinder_driver':
	line => "volume_driver = cinder.volume.drivers.nfs.NfsDriver",
	after => "nfs_shares_config",
	path => "/etc/cinder/cinder.conf",
	notify => Service[$cinder],
	}
cinder_config { 'DEFAULT/nfs_shares_config':
	ensure => 'present',
	value => "/etc/cinder/nfsshare",
	notify => Service[$cinder],
	}
cinder_config { 'DEFAULT/volume_driver':
	ensure => 'present',
	value => "cinder.volume.drivers.nfs.NfsDriver",
	notify => Service[$cinder],
	}
