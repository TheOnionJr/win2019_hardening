
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

Briefly tell users why they might want to use your module. Explain what your module does and what kind of problems users can solve with it.

This should be a fairly short description helps the user decide if your module is what they want.

This module is for Windows server (2019) security hardening.

	The module...

## Setup

To choose if the computer can shut off while a user is logged in or not, change the boolean (Boolean $no_auto_reboot_with_logged_on_users = true) in manifests/init.pp. 
True (it can not reboot with users logged in) is default, change to false to allow reboots while a user is logged on. 

### What win2019_hardening affects **OPTIONAL**

If it's obvious what your module touches, you can skip this section. For example, folks can probably figure out that your mysql_instance module affects their MySQL instances.

If there's more that they should know about, though, this is the place to mention:

* Files, packages, services, or operations that the module will alter, impact, or execute.
* Dependencies that your module automatically installs.
* Warnings or other important notices.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled, another module, etc.), mention it here.

If your most recent release breaks compatibility or requires particular steps for upgrading, you might want to include an additional "Upgrading" section here.

This module has a few dependencies:

 *	Registry editor for windows: https://forge.puppet.com/puppetlabs/registry 
 *	Tool for rebooting the machine: https://forge.puppet.com/puppetlabs/reboot
 *	Security policy editor for windows: https://forge.puppet.com/ayohrling/local_security_policy 
 *	PowerShell Desired State Configurator: https://forge.puppet.com/puppetlabs/dsc
 *	Firewall rules editor: https://forge.puppet.com/puppet/windows_firewall/readme
 *	Windows audit policies manager: https://forge.puppet.com/jonono/auditpol
	

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
