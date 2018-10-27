# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include win2019_hardening::config
class win2019_hardening::config {
	dsc_xtimezone { 'Oslo':
    	dsc_timezone         => 'W. Europe Standard Time',
    	dsc_issingleinstance => 'yes',
  	}
	dsc_windowsfeature {'FS-SMB1':
		dsc_ensure => 'absent',
    	dsc_name   => 'FS-SMB1',
  	}
  	dsc_registry {'EnableMulticast':
  		dsc_ensure 		=> 'Present',
  		dsc_key			=> 'HKEY_LOCAL_MACHINE\NETWORK\DNS_Client'
  		dsc_valuename   => 'EnableMulticast',
  		dsc_valuedata 	=> '1',
  		dsc_valuetype 	=> 'Dword',
  	}
	#Adding NodeType to NetBT registry, to avoid NBT-NS (Netbios) poisioning.
	registry_value { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\NodeType' :
		ensure  => present,
		type	=> dword,
		data    => 2,
	}
}
