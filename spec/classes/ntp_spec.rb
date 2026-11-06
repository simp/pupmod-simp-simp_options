require 'spec_helper'

describe 'simp_options' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default parameters for simp_options::ntp' do
        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_class('simp_options::ntp').with(
          servers: [],
        )
        }
      end

      context 'hash configuration for simp_options::ntp' do
        let(:hieradata) { 'simp_options_with_ntp_hash' }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_class('simp_options::ntp').with(
          servers: {
            'ntp1.example.com' => [
              'minpoll 3',
              'maxpoll 6',
            ],
            'ntp2.example.com' => [
              'iburst',
              'minpoll 4',
              'maxpoll 8',
            ]
          },
        )
        }
      end

      # The Simplib::Host elements of $servers must reject a dotted-decimal
      # address with an out-of-range octet. This requires simp/simplib 7.0.0
      # or later; before that, Simplib::Hostname matched '1.2.3.400' as a
      # host name. See simp/pupmod-simp-simplib#351.
      context 'invalid ntp servers' do
        let(:hieradata) { 'simp_options_with_invalid_ntp_servers' }

        it { is_expected.not_to compile.with_all_deps }
      end

      context 'invalid ntp servers in a hash' do
        let(:hieradata) { 'simp_options_with_invalid_ntp_hash' }

        it { is_expected.not_to compile.with_all_deps }
      end
    end
  end
end
