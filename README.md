
# win2019_hardening

#### Table of Contents

1. [Description](#description)
	* [What win2019_hardening affects](#what-win2019_hardening-affects)
2. [Setup - The basics of getting started with win2019_hardening](#setup)
    * [Setup requirements](#setup-requirements)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This module combines the use of several modules to harden the security of Windows Server 2019.
The module changes several settings on the machine, that mitigates several security-holes, as well as setting up auditing to Microsoft's "Strong Recommendation". (Which is recommended for systems where security and useability is important)


### What win2019_hardening affects 

 * ~~Sets the timezone to W. Europe Standard Time.~~
 * Disables the SMB1 protocol, to prevent eternal-blue.
 * Adds two registry keys and sets values in NetBT, to prevent Netbios poisioning. ***
 * Sets Windows Update(WU) to automatically update.
	* Ensures that WU is set to "Auto downlaod and notify on install"
	* Sets installation of WUs to friday afternoon (Fri 17:00)
	* Sets wether computer can reboot (to install updates) while a user is logged in (configurable)
 * Denying outgoing NTLM traffic to remote servers, to avoid hash-dumping.
 * Closing several ports using firewall-rules. (List can be found in data/common.yaml)
 * Sets the auditing policy to Microsoft's "Stronger Recommendation" (As described here: https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/plan/security-best-practices/audit-policy-recommendations)
 * Reboots (Given changes that require reboot has been changed).


## Setup

To use this module, you need Puppet-agent (Tested with Puppet 5.5.7/5.5.8) to be installed on your system.
We also recommend a variation of Git to clone the repository directly.

Clone the repository into C:\ProgramData\PuppetLabs\code\environments\production\modules (ProgramData is a hidden folder, if you are using GUI you might need to enable "Show hidden files, folders, and drives")
Install all the dependent puppet modules. (Links with instructions found under Setup Requirements section further down)

To choose if the computer can shut off while a user is logged in or not, change the boolean (Boolean $no_auto_reboot_with_logged_on_users = true) in manifests/init.pp. 
True (it can not reboot with users logged in) is default, change to false to allow reboots while a user is logged on. 

NB!! Run Puppet as administrator!
To run the module, run "puppet apply" on the file "execute.pp", located in the win2019_hardening directory.


### Setup Requirements

Only tested on Windows Server 2019 Standard Evaluation, with Puppet 5.5.7/5.5.8.

This module has dependencies:

 *	Registry editor for windows: https://forge.puppet.com/puppetlabs/registry 
 *	Tool for rebooting the machine: https://forge.puppet.com/puppetlabs/reboot
 *	~~Security policy editor for windows: https://forge.puppet.com/ayohrling/local_security_policy~~ 
 *	PowerShell Desired State Configurator: https://forge.puppet.com/puppetlabs/dsc
 *	Firewall rules editor: https://forge.puppet.com/puppet/windows_firewall/readme
 *	Windows audit policies manager: https://forge.puppet.com/jonono/auditpol
 *  Windows powershell command execution: https://forge.puppet.com/puppetlabs/powershell	


## Usage
You run the module with puppet-console as administrator:

`puppet apply win2019_hardening\execute.pp`

## Limitations

Limited to Windows. 
Other than Server 2019, unknown.

## Development

