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
  	#Eternal blue prevention:
	dsc_windowsfeature {'FS-SMB1':
		dsc_ensure => 'absent',
    	dsc_name   => 'FS-SMB1',
  	}
  	#Netbios poisoning prevention:
  	registry_value {'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\NodeType':
  		ensure 	=> present,
  		type 	=> dword,
  		data 	=> 2,
#		notify  => Reboot['after_run'],
  	}
	#Adding NodeType to NetBT registry, to avoid NBT-NS (Netbios) poisioning.
	registry_value { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\NodeType' :
		ensure  => present,
		type	=> dword,
		data    => 2,
#		notify  => Reboot['after_run'],
	}
	#Denying outgoing NTLM traffic to remote servers. To avoid hash dumping.
	local_security_policy { 'Network security: Restrict NTLM: Outgoing NTLM traffic to remote servers':
		ensure         => 'present',
		policy_setting => 'MACHINE\System\CurrentControlSet\Control\Lsa\MSV1_0\RestrictSendingNTLMTraffic',
		policy_type    => 'Registry Values',
		policy_value   => '2',
	}

	#Blacklisting ports:
	$blacklist_in = lookup('config::blacklist_in')

	$blacklist_in.each |Integer $port, String $protocol| {
		windows_firewall::exception { 'Blacklist_in'
		ensure      => present,
		direction   => 'in',
		action      => 'block',
		enabled     => true,
		protocol    => ${protocol},
		local_port  => ${port},
		remote_port => 'any',
		}
	}

	$blacklist_in = lookup('config::blacklist_out')

	$blacklist_in.each |Integer $port, String $protocol| {
		windows_firewall::exception { 'Blacklist_out'
		ensure      => present,
		direction   => 'out',
		action      => 'block',
		enabled     => true,
		protocol    => ${protocol},
		local_port  => ${port},
		remote_port => 'any',
		}
	}

	#Whitelisting ports:
	$whitelist_in = lookup('config::whitelist_in')

	$whitelist_in.each |Integer $port, String $protocol| {
		windows_firewall::exception { 'whitelist_in'
		ensure      => present,
		direction   => 'in',
		action      => 'allow',
		enabled     => true,
		protocol    => ${protocol},
		local_port  => ${port},
		remote_port => 'any',
		}
	}

	$whitelist_out = lookup('config::whitelist_out')

	$whitelist_out.each |Integer $port, String $protocol| {
		windows_firewall::exception { 'whitelist_out'
			ensure 	    => present,
			direction   => 'out',
			action      => 'allow',
			enabled     => true,
			protocol    => ${protocol},
			local_port  => ${port},
			remote_port => 'any',
		}
	}
}
#Temporary code
#class tempForReboot {
#	reboot { 'after_run':
#		apply => finished,
#	} 
#}