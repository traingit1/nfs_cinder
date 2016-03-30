notice('MODULAR: cinder_nfs.pp')
package { 'nfs-common':
        ensure => 'installed',
        }
service { 'nfs-common':
	ensure => running,
	enable => true,
	}
