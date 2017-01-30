require 'spec_helper'

describe 'simp_options' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do

        context 'defaults' do
          it { is_expected.to compile.with_all_deps }
          it {
            is_expected.to contain_class('simp_options::openssl').with(
              :cipher_suite => ['DEFAULT', '!MEDIUM']
            )
          }
        end

        context 'defaults for simp_options::openssl with FIPS enabled and the fips_ciphers fact unavailable' do
          let(:facts){{ :fips_enabled => true }}
          it { expect { is_expected.to compile.with_all_deps }.to raise_error(/not found/) }
        end

        context 'defaults for simp_options::openssl with FIPS enabled and the fips_ciphers fact available' do
          let(:facts){{
            :fips_enabled => true,
            :fips_ciphers => ["ECDHE-RSA-AES256-GCM-SHA384","ECDHE-ECDSA-AES256-GCM-SHA384","other totally legit FIPS cipher"]
          }}
          it { is_expected.to compile.with_all_deps }
          it {
            is_expected.to contain_class('simp_options::openssl').with(
              :cipher_suite => ["ECDHE-RSA-AES256-GCM-SHA384","ECDHE-ECDSA-AES256-GCM-SHA384","other totally legit FIPS cipher"]
            )
          }
        end

      end
    end
  end
end
