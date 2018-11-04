
# win2019_hardening

Welcome to your new module. A short overview of the generated parts can be found in the PDK documentation at https://puppet.com/pdk/latest/pdk_generating_modules.html .

The README template below provides a starting point with details about what information to include in your README.

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with win2019_hardening](#setup)
    * [What win2019_hardening affects](#what-win2019_hardening-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with win2019_hardening](#beginning-with-win2019_hardening)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This module combines the use of several modules to harden the security of Windows Server 2019.
The module changes several settings on the machine, that mitigates several security-holes, as well as setting up auditing to Microsoft's "Strong Recommendation". (Which is recommended for systems where security and useability is important)


### What win2019_hardening affects 

 * Sets the timezone to W. Europe Standard Time.
 * Disables the SMB1 protocol, to prevent eternal-blue.
 * Adds two registry keys and sets values in NetBT, to prevent Netbios poisioning. ***
 * Sets Windows Update(WU) to automatically update.
	* Ensures that WU is set to "Auto downlaod and notify on install"
	* Sets installation of WUs to friday afternoon (Fri 17:00)
	* Sets wether computer can reboot (to install updates) while a user is logged in (configurable)
 * Denying outgoing NTLM traffic to remote servers, to avoid hash-dumping.
 * Firewall......... (!!)
 * Sets the auditing policy to Microsoft's "Stronger Recommendation" (As described here: https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/plan/security-best-practices/audit-policy-recommendations)
 * Reboots (Given changes that require reboot has been changed).


## Setup

To use this module, you need Puppet-agent (Tested with Puppet 5.5.7/latest as of late October 2018) to be installed on your system.
We also recommend a variation of Git to clone the repository directly.

Clone the repository into C:\ProgramData\PuppetLabs\code\environments\production\modules
Install all the dependent puppet modules.

To choose if the computer can shut off while a user is logged in or not, change the boolean (Boolean $no_auto_reboot_with_logged_on_users = true) in manifests/init.pp. 
True (it can not reboot with users logged in) is default, change to false to allow reboots while a user is logged on. 

NB!! Run Puppet as administrator!
To run the module, run "puppet apply" on the file "execute.pp", located in the win2019_hardening directory.


### Setup Requirements

Only tested on Windows Server 2019 Standard Evaluation.

This module has dependencies:

 *	Registry editor for windows: https://forge.puppet.com/puppetlabs/registry 
 *	Tool for rebooting the machine: https://forge.puppet.com/puppetlabs/reboot
 *	~~Security policy editor for windows: https://forge.puppet.com/ayohrling/local_security_policy~~ 
 *	PowerShell Desired State Configurator: https://forge.puppet.com/puppetlabs/dsc
 *	Firewall rules editor: https://forge.puppet.com/puppet/windows_firewall/readme
 *	Windows audit policies manager: https://forge.puppet.com/jonono/auditpol
 *  Windows powershell command execution: https://forge.puppet.com/puppetlabs/powershell	

### Beginning with win2019_hardening

The very basic steps needed for a user to get the module up and running. This can include setup steps, if necessary, or it can be an example of the most basic use of the module.

## Usage

Include usage examples for common use cases in the **Usage** section. Show your users how to use your module to solve problems, and be sure to include code examples. Include three to five examples of the most important or common tasks a user can accomplish with your module. Show users how to accomplish more complex tasks that involve different types, classes, and functions working in tandem.

## Reference

This section is deprecated. Instead, add reference information to your code as Puppet Strings comments, and then use Strings to generate a REFERENCE.md in your module. For details on how to add code comments and generate documentation with Strings, see the Puppet Strings [documentation](https://puppet.com/docs/puppet/latest/puppet_strings.html) and [style guide](https://puppet.com/docs/puppet/latest/puppet_strings_style.html)

If you aren't ready to use Strings yet, manually create a REFERENCE.md in the root of your module directory and list out each of your module's classes, defined types, facts, functions, Puppet tasks, task plans, and resource types and providers, along with the parameters for each.

For each element (class, defined type, function, and so on), list:

  * The data type, if applicable.
  * A description of what the element does.
  * Valid values, if the data type doesn't make it obvious.
  * Default value, if any.

For example:

```
### `pet::cat`

#### Parameters

##### `meow`

Enables vocalization in your cat. Valid options: 'string'.

Default: 'medium-loud'.
```

## Limitations

In the Limitations section, list any incompatibilities, known issues, or other warnings.

## Development

In the Development section, tell other users the ground rules for contributing to your project and how they should submit their work.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You can also add any additional sections you feel are necessary or important to include here. Please use the `## ` header.
