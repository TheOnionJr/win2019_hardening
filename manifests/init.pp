# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include win2019_hardening
class win2019_hardening (
	Boolean $no_auto_reboot_with_logged_on_users = true,
	Array $blacklist_in,
	Array $blacklist_out,
	Array $whitelist_in,
	Array $whitelist_out)
	{
	contain win2019_hardening::install
	contain win2019_hardening::config
	
	Class['::win2019_hardening::install']
	-> Class['::win2019_hardening::config']
}
