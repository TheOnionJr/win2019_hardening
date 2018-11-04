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
		#Making sure the registry key exists
	registry_key { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0\RestrictSendingNTLMTraffic' :
		ensure => present,
	}
		#Setting the security policy to DenyAll
	local_security_policy { 'Network security: Restrict NTLM: Outgoing NTLM traffic to remote servers':
		ensure         => 'present',
		policy_setting => 'MACHINE\System\CurrentControlSet\Control\Lsa\MSV1_0\RestrictSendingNTLMTraffic',
		policy_type    => 'Registry Values',
		policy_value   => '2',
	}

	#Blacklisting ports:
	$win2019_hardening::blacklist_in.each |$port| {
		exec { "${port}_blacklist_in_tcp":
			command => "New-NetFirewallRule -DisplayName \"${port}_blacklist_in_tcp\" -Direction Inbound -LocalPort ${port} -Protocol TCP -Action Block -Enabled true",
			provider => powershell,
			returns => 0,
			onlyif => "if(Get-NetFirewallRule -DisplayName \"${port}_blacklist_in_tcp\") {\$LASTEXITCODE = 1} else {return 0}",
		}
	}
	$win2019_hardening::blacklist_in.each |$port| {
		exec { "${port}_blacklist_in_udp":
			command => "New-NetFirewallRule -DisplayName \"${port}_blacklist_in_udp\" -Direction Inbound -LocalPort ${port} -Protocol UDP -Action Block -Enabled true",
			provider => powershell,
			returns => 0,
			onlyif => "if(Get-NetFirewallRule -DisplayName \"${port}_blacklist_in_udp\") {\$LASTEXITCODE = 1} else {return 0}",
		}
	}
	$win2019_hardening::blacklist_out.each |$port| {
		exec { "${port}_blacklist_out_tcp":
			command => "New-NetFirewallRule -DisplayName \"${port}_blacklist_out_tcp\" -Direction Outbound -LocalPort ${port} -Protocol TCP -Action Block -Enabled true",
			provider => powershell,
			returns => 0,
			onlyif => "if(Get-NetFirewallRule -DisplayName \"${port}_blacklist_out_tcp\") {\$LASTEXITCODE = 1} else {return 0}",
		}
	}
	$win2019_hardening::blacklist_out.each |$port| {
		exec { "${port}_blacklist_out_udp":
			command => "New-NetFirewallRule -DisplayName \"${port}_blacklist_out_udp\" -Direction Outbound -LocalPort ${port} -Protocol UDP -Action Block -Enabled true",
			provider => powershell,
			returns => 0,
			onlyif => "if(Get-NetFirewallRule -DisplayName \"${port}_blacklist_out_udp\") {\$LASTEXITCODE = 1} else {return 0}",
		}
	}
	#Whitelisting porsts:
	$win2019_hardening::whitelist_in.each |$port| {
		exec { "${port}_whitelist_in_tcp":
			command => "New-NetFirewallRule -DisplayName \"${port}_whitelist_in_tcp\" -Direction Inbound -LocalPort ${port} -Protocol TCP -Action Allow -Enabled true",
			provider => powershell,
			returns => 0,
			onlyif => "if(Get-NetFirewallRule -DisplayName \"${port}_whitelist_in_tcp\") {\$LASTEXITCODE = 1} else {return 0}",
		}
	}
	$win2019_hardening::whitelist_in.each |$port| {
		exec { "${port}_whitelist_in_udp":
			command => "New-NetFirewallRule -DisplayName \"${port}_whitelist_in_tcp\" -Direction Inbound -LocalPort ${port} -Protocol UDP -Action Allow -Enabled true",
			provider => powershell,
			returns => 0,
			onlyif => "if(Get-NetFirewallRule -DisplayName \"${port}_whitelist_in_tcp\") {\$LASTEXITCODE = 1} else {return 0}",
		}
	}
	$win2019_hardening::whitelist_out.each |$port| {
		exec { "${port}_whitelist_out_tcp":
			command => "New-NetFirewallRule -DisplayName \"${port}_whitelist_out_tcp\" -Direction Outbound -LocalPort ${port} -Protocol TCP -Action Allow -Enabled true",
			provider => powershell,
			returns => 0,
			onlyif => "if(Get-NetFirewallRule -DisplayName \"${port}_whitelist_out_tcp\") {\$LASTEXITCODE = 1} else {return 0}",
		}
	}
	$win2019_hardening::whitelist_out.each |$port| {
		exec { "${port}_whitelist_out_udp":
			command => "New-NetFirewallRule -DisplayName \"${port}_whitelist_out_udp\" -Direction Outbound -LocalPort ${port} -Protocol UDP -Action Allow -Enabled true",
			provider => powershell,
			returns => 0,
			onlyif => "if(Get-NetFirewallRule -DisplayName \"${port}_whitelist_out_udp\") {\$LASTEXITCODE = 1} else {return 0}",
		}
	}
	#Setting auditing policy to Microsoft's "Stronger Recommendation"
	auditpol { 'Credential Validation':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'Kerberos Authentication Service':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'Kerberos Service Ticket Operations':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'Other Account Logon Events':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'Computer Account Management':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'Other Account Management Events':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'Security Group Management':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'User Account Management':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'Process Creation':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'Account Lockout':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'Logoff':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'Logon':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'Other Logon/Logoff Events':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'Special Logon':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'Audit Policy Change':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'Authentication Policy Change':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'MPSSVC Rule-Level Policy Change':
		success => 'enable',
	}
	auditpol { 'IPsec Driver':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'Security State Change':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'Security System Extension':
		success => 'enable',
		failure => 'enable',
	}
	auditpol { 'System Integrity':
		success => 'enable',
		failure => 'enable',
	}
	#This is mainly to show off downloading a file and running it from the internet.
	#It would be easier to run this in the registry module, but we wanted to show off our puppet skills.
	file { 'EnableMulticast':
  		ensure => present,
  		path   => 'C:/Program Files/enablemulticasts.ps1',
  		owner  => 'Admin',
  		group  => 'Administrators',
  		mode   => '0660',
  		source => 'https://bitbucket.org/SanderLB/win2019_hardening/raw/f51158cfeec16467013e23640c652138c67d4829/ps1/enablemulticast.ps1',
	}
	exec { 'Run Multicast':
		command => 'C:/Program Files/enablemulticasts.ps1',
		provider => powershell,
	}	
}
#Temporary code
#class tempForReboot {
#	reboot { 'after_run':
#		apply => finished,
#	} 
#}