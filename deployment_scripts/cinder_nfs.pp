notice('MODULAR: cinder_nfs.pp')
$cinder_nfs = hiera('cinder_nfs', {})
$server_ip = pick($cinder_nfs['server_ip'], {})
$share_name = pick($cinder_nfs['share_name'], {})
$cinder = [ 'cinder-api', 'cinder-scheduler','cinder-volume']

service { $cinder:
	ensure => 'running',
}
package { 'nfs-common':
	ensure => 'installed',
	}
package { 'cinder-volume':
	ensure => 'installed',
	}
file { '/etc/cinder':
	ensure => 'directory',
	}
file { '/etc/cinder/nfsshare':
	ensure => 'present',
	content => "$server_ip:$share_name",
	owner => 'root',
	group => 'cinder',
	mode => '0640',
	require => File['/etc/cinder'],
	}
cinder_config { 'DEFAULT/nfs_shares_config':
	ensure => 'present',
	value => "/etc/cinder/nfsshare",
	notify => Service[$cinder],
	require => Package['nfs-common'],
	}
cinder_config { 'DEFAULT/volume_driver':
	ensure => 'present',
	value => "cinder.volume.drivers.nfs.NfsDriver",
	notify => Service[$cinder],
	require => Package['nfs-common'],
	}
