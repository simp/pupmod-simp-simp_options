require 'spec_helper'

describe 'simp_options' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts.merge({ domain: 'example.com' }) }

        context 'default parameters for simp_options::ldap' do
          let(:hieradata) { 'simp_options_with_ldap' }

          it { is_expected.to compile.with_all_deps }
          # make sure interpolation of hieradata in modules's data/ is working
          it {
            is_expected.to contain_class('simp_options::ldap').with(
              base_dn: 'DC=example,DC=com',
              bind_dn: 'cn=hostAuth,ou=Hosts,DC=example,DC=com',
              bind_pw: 'N0t=@=R#@l=B1nd=P@ssw0rd',
              bind_hash: '{SSHA}DEADBEEFdeadbeefDEADBEEFdeadbeef',
              sync_dn: 'cn=LDAPSync,ou=Hosts,DC=example,DC=com',
              sync_pw: 'N0t=@=R#@l=Sync=P@ssw0rd',
              sync_hash: '{SSHA}DeadBeerDeadBeefDeadBeefDeadBeef',
              root_dn: 'cn=LDAPAdmin,ou=People,DC=example,DC=com',
              master: 'ldap://puppet.example.com',
              uri: ['ldap://puppet.example.com'],
            )
          }
        end

        context 'invalid simp_options::ldap::master' do
          let(:hieradata) { 'simp_options_with_invalid_ldap_master' }

          it { is_expected.not_to compile.with_all_deps }
        end

        context 'invalid simp_options::ldap::uri' do
          let(:hieradata) { 'simp_options_with_invalid_ldap_uri' }

          it { is_expected.not_to compile.with_all_deps }
        end
      end
    end
  end
end
