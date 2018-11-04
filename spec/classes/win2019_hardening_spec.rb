require 'spec_helper'

describe 'win2019_hardening' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_class('win2019_hardening::install').that_comes_before('Class[win2019_hardening::config]')}
      it { is_expected.to contain_class('win2019_hardening::config')}
      it { is_expected.to have_class_count(3)}
    end
  end
end
