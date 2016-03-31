notice('MODULAR: compute_nfs.pp')
package { 'nfs-common':
        ensure => 'installed',
        }
package { 'cifs-utils':
	ensure => 'installed',
	}
