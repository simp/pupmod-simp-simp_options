require 'spec_helper'

shared_examples_for 'a simp_options class' do
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('simp_options::dns') }
  it { is_expected.to contain_class('simp_options::ntpd') }
  it { is_expected.to contain_class('simp_options::openssl') }
  it { is_expected.to contain_class('simp_options::puppet') }
  it { is_expected.to contain_class('simp_options::rsync') }
  it { is_expected.to contain_class('simp_options::uid') }
  it { is_expected.to contain_class('simp_options::gid') }
end

describe 'simp_options' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        context 'default parameters' do
          it_behaves_like 'a simp_options class'
        end

        context 'with ldap enabled' do
          context 'with the simp_options::puppet settings set' do
            let(:hieradata) { "#{class_name}_with_ldap" }
            let(:params) { { ldap: true } }

            it_behaves_like 'a simp_options class'
            it { is_expected.to contain_class('simp_options::ldap') }
          end

          context 'without the simp_options::puppet settings set' do
            let(:hieradata) { "#{class_name}_with_ldap_missing_puppet" }
            let(:params) { { ldap: true } }

            it { expect { is_expected.to compile.with_all_deps }.to raise_error(%r{parameter .+ expects}) }
          end
        end

        context 'with pki=true' do
          let(:hieradata) { "#{class_name}_with_pki_true" }
          let(:params) { { pki: true } }

          it_behaves_like 'a simp_options class'
          it { is_expected.to contain_class('simp_options::pki') }
        end

        context 'with pki=simp' do
          let(:hieradata) { "#{class_name}_with_pki_simp" }
          let(:params) { { pki: true } }

          it_behaves_like 'a simp_options class'
          it { is_expected.to contain_class('simp_options::pki') }
        end

        context 'with syslog enabled' do
          let(:hieradata) { class_name }
          let(:params) { { syslog: true } }

          it_behaves_like 'a simp_options class'
          it { is_expected.to contain_class('simp_options::syslog') }
        end

        context 'invalid trusted_nets' do
          let(:hieradata) { class_name }
          let(:params) { { trusted_nets: ['1.2.3.400'] } }

          it { is_expected.not_to compile.with_all_deps }
        end
      end
    end
  end
end
