require 'spec_helper'

describe 'simp_options::ldap' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|

      context "on #{os}" do
        let(:facts){ facts }

        context 'default parameters' do
          let(:hieradata) { 'simp_options_with_ldap' }
          it { is_expected.to compile.with_all_deps }
          # make sure interpolation of hieradata in modules's data/ is working
          it { 
            is_expected.to contain_class('simp_options::ldap').with(
              :base_dn   => 'dc=example,dc=com',
              :bind_dn   => 'cn=hostAuth,ou=Hosts,dc=example,dc=com',
              :bind_pw   => 'N0t=@=R#@l=B1nd=P@ssw0rd',
              :bind_hash => '{SSHA}DEADBEEFdeadbeefDEADBEEFdeadbeef',
              :sync_dn   => 'cn=LDAPSync,ou=Hosts,dc=example,dc=com',
              :sync_pw   => 'N0t=@=R#@l=Sync=P@ssw0rd',
              :sync_hash => '{SSHA}DeadBeerDeadBeefDeadBeefDeadBeef',
              :root_dn   => 'cn=LDAPAdmin,ou=People,dc=example,dc=com',
              :root_hash => '{SSHA}deadbeefDEADBEEFdeadbeefDEADBEEF',
              :master    => 'ldap://puppet.example.com',
              :uri       => ['ldap://puppet.example.com']
            )
          }
        end

        context 'invalid master' do
          let(:hieradata) { 'simp_options_with_ldap' }
          let(:params){{ :master => '1.2.3.400' }}
          it { is_expected.not_to compile.with_all_deps }
        end

        context 'invalid uri' do
          let(:hieradata) { 'simp_options_with_ldap' }
          let(:params){{ :uri => ['1.2.3.500'] }}
          it { is_expected.not_to compile.with_all_deps }
        end
      end
    end
  end
end
