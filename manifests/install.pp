# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include win2019_hardening::install
class win2019_hardening::install {
	$win_sw_pkg = lookup('base_windows::win_sw_pkg')

  	include chocolatey
  	
	case $::operatingsystem {
    	'windows':
      	{ Package { provider => chocolatey, } }
    	default:
    	{ Package { provider => windows, } }
	}
}
