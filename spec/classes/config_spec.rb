require 'spec_helper'

describe 'win2019_hardening::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:node_params) do 
      	{ 'win2019_hardening::no_auto_reboot_with_logged_on_users' => 'true',
      	  'win2019_hardening::blacklist_in' => ['21', '22', '445'],
      	  'win2019_hardening::blacklist_out' => ['21', '22', '445'],
      	  'win2019_hardening::whitelist_in' => ['3389'],
      	  'win2019_hardening::whitelist_out' => ['3389'],
      	}
      end

      it { is_expected.to compile }

      it { is_expected.to contain_exec('Run Multicast').with(
      	'command'  => 'C:/Program Files/enablemulticasts.ps1',
    	'provider' => 'powershell',
    	)
  	  }
      it { is_expected.to contain_auditpol('Kerberos Authentication Service').with(
      		'success' => 'enable',
    		'failure' => 'enable',
      	)
      }
      it { is_expected.to contain_registry_value('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\NodeType').with(
      	  'ensure' => 'present',
   		  'type'   => 'dword',
    	  'data'   => '2',
    	  'notify' => 'Reboot[after_run]',
      	)
      }
      it { is_expected.to contain_file('EnableMulticast').with(
      	  'ensure' => 'present',
          'path'   => 'C:/Program Files/enablemulticasts.ps1',
      	  'owner'  => 'Admin',
      	  'group'  => 'Administrators',
      	  'mode'   => '0660',
      	  'source' => 'https://bitbucket.org/SanderLB/win2019_hardening/raw/f51158cfeec16467013e23640c652138c67d4829/ps1/enablemulticast.ps1',
      	)
      }
    end
  end
end
