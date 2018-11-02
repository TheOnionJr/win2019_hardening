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
		#Ensuring automatic windows updates:
	registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAutoUpdate' :
		ensure => present,
		type   => dword,
		data   => 0,
#		notify => Reboot['after_run'],
	}
	#Ensuring Automatic updates are set to "Auto download and notify on install"
	registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\AUOptions' :
		ensure => present,
		type   => dword,
		data   => 3,
#		notify => Reboot['after_run'],
	}
	#Setting update-install time to friday afternoon (to allow for weekend-fix and max uptime in reg. work-hours)
		#Update-day set to friday.
	registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\ScheduledInstallDay' :
		ensure => present,
		type   => dword,
		data   => 6,
#		notify => Reboot['after_run'],
	}
		#Update-hour set to 17.
	registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\ScheduledInstallTime' :
		ensure => present,
		type   => dword,
		data   => 17,
#		notify => Reboot['after_run'],
	}
	#Setting if computer will reboot while a user is logged in (Auto-update), based on config (default true).
	if($win2019_hardening::no_auto_reboot_with_logged_on_users) {
		registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAutoRebootWithLoggedOnUsers' :
			ensure => present,
			type   => dword,
			data   => 1,
#			notify => Reboot['after_run'],
		}
	} else {
		registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAutoRebootWithLoggedOnUsers' :
			ensure => present,
			type   => dword,
			data   => 0,
#			notify => Reboot['after_run'],
		}
	}
	#Denying outgoing NTLM traffic to remote servers. To avoid hash dumping.
	local_security_policy { 'Network security: Restrict NTLM: Outgoing NTLM traffic to remote servers':
		ensure         => 'present',
		policy_setting => 'MACHINE\System\CurrentControlSet\Control\Lsa\MSV1_0\RestrictSendingNTLMTraffic',
		policy_type    => 'Registry Values',
		policy_value   => '2',
	}
	
	class { 'windows_firewall': ensure => 'stopped' }
	#Blacklisting ports:
	$blacklist_in = lookup('config::blacklist_in')

	$blacklist_in.each |$port, $protocol| {
		windows_firewall::exception { 'Blacklist_in':
		ensure      => present,
		direction   => 'in',
		action      => 'block',
		enabled     => true,
		protocol    => $protocol,
		local_port  => $port,
		remote_port => 'any',
		}
	}

	$blacklist_in = lookup('config::blacklist_out')

	$blacklist_in.each |$port, $protocol| {
		windows_firewall::exception { 'Blacklist_out':
		ensure      => present,
		direction   => 'out',
		action      => 'block',
		enabled     => true,
		protocol    => $protocol,
		local_port  => $port,
		remote_port => 'any',
		}
	}

	#Whitelisting ports:
	$whitelist_in = lookup('config::whitelist_in')

	$whitelist_in.each |$port, $protocol| {
		windows_firewall::exception { 'whitelist_in':
		ensure      => present,
		direction   => 'in',
		action      => 'allow',
		enabled     => true,
		protocol    => $protocol,
		local_port  => $port,
		remote_port => 'any',
		}
	}

	$whitelist_out = lookup('config::whitelist_out')

	$whitelist_out.each |$port, $protocol| {
		windows_firewall::exception { 'whitelist_out':
			ensure 	    => present,
			direction   => 'out',
			action      => 'allow',
			enabled     => true,
			protocol    => $protocol,
			local_port  => $port,
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