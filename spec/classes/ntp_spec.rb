require 'spec_helper'

describe 'simp_options' do
  on_supported_os.each do |os, os_facts|

    context "on #{os}" do
      let(:facts){ os_facts }

      context 'default parameters for simp_options::ntp' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('simp_options::ntp').with(
          :servers => []
        ) }
      end

      context 'hash configuration for simp_options::ntp' do
        let(:hieradata) { 'simp_options_with_ntp_hash' }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('simp_options::ntp').with(
          :servers => {
            'ntp1.example.com' => [
              'minpoll 3',
              'maxpoll 6',
            ],
            'ntp2.example.com' => [
              'iburst',
              'minpoll 4',
              'maxpoll 8',
            ]
          }
        ) }
      end
    end
  end
end
