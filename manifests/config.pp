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
  	dsc_registry {'NetbiosOptions':
  		dsc_ensure 		=> 'Present',
  		dsc_key			=> 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\Tcpip_{e3f726bc-8f9f-4c26-8ef4-166b150949cc}',
  		dsc_valuename   => 'NetbiosOptions',
  		dsc_valuedata 	=> '2',
  		dsc_valuetype 	=> 'Dword',
  	}
	#Adding NodeType to NetBT registry, to avoid NBT-NS (Netbios) poisioning.
	registry_value { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\NodeType' :
		ensure  => present,
		type	=> dword,
		data    => 2,
	}
	#Denying outgoing NTLM traffic to remote servers. To avoid hash dumping.
	local_security_policy { 'Network security: Restrict NTLM: Outgoing NTLM traffic to remote servers':
		ensure         => 'present',
		policy_setting => 'MACHINE\System\CurrentControlSet\Control\Lsa\MSV1_0\RestrictSendingNTLMTraffic',
		policy_type    => 'Registry Values',
		policy_value   => '2',
	}
}
