require 'spec_helper'

# Other modules' simp:defaults compliance profiles alias simp_options::firewall,
# so a plain Hiera lookup must resolve even when no site data sets it and the
# simp_options class is not included.
describe 'lookup' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with no site data for simp_options::firewall' do
        it { is_expected.to run.with_params('simp_options::firewall').and_return(false) }
      end

      context 'with site data setting simp_options::firewall to true' do
        let(:hieradata) { 'simp_options_firewall_true' }

        it { is_expected.to run.with_params('simp_options::firewall').and_return(true) }
      end
    end
  end
end
