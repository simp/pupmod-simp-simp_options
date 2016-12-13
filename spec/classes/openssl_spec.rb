require 'spec_helper'

describe 'simp_options' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|

      context "on #{os}" do

        context 'defaults for simp_options::openssl with FIPS enabled' do
          let(:facts){{ :fips_enabled => true }}
          it { is_expected.to compile.with_all_deps }
          it { 
            is_expected.to contain_class('simp_options::openssl').with(
              :cipher_suite => ['FIPS', "!LOW"]
            )
          }
        end

        context 'defaults for simp_options::openssl without FIPS enabled' do
          let(:facts){{ :fips_enabled => false }}
          it { is_expected.to compile.with_all_deps }
          it {
            is_expected.to contain_class('simp_options::openssl').with(
              :cipher_suite => ['DEFAULT', '!MEDIUM']
            )
         }
        end
      end
    end
  end
end
