require 'spec_helper'

describe 'simp_options::openssl' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|

      context "on #{os}" do

        context 'defaults with FIPS enabled' do
          let(:facts){{ :fips_enabled => true }}
          it { is_expected.to compile.with_all_deps }
          it { 
            is_expected.to contain_class('simp_options::openssl').with(
              :cipher_suite => ['FIPS', "!LOW", "!COMPLIMENTOFDEFAULT"]
            )
          }
        end

        #HACK When fips_enabled fact is false, puppet lookup returns empty string
        # instead of false.  To workaround this bug, in the module hiera.yaml we set
        # the path for the fips_enabled module data to 
        #   "fips_enabled/is_%{facts.fips_enabled}"
        # instead of 
        #   "fips_enabled/%{facts.fips_enabled}"
        #  and populate data/fips_enabled with
        #   is_true.yaml
        #   is_false.yaml
        #   is_.yaml <-- link to is_false.yaml
        #FIXME When puppet lookup is fixed, remove link and 'is_' prefix.
        context 'defaults without FIPS enabled' do
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
