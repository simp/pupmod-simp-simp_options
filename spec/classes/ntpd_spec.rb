require 'spec_helper'

describe 'simp_options' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        context 'default parameters for simp_options::ntpd' do
          let(:hieradata) { 'simp_options' }

          it { is_expected.to compile.with_all_deps }
          it {
            is_expected.to contain_class('simp_options::ntpd').with(
            servers: [],
          )
          }
        end

        context 'invalid ntpd servers' do
          let(:hieradata) { 'simp_options_with_invalid_ntpd_servers' }

          it { is_expected.not_to compile.with_all_deps }
        end
      end
    end
  end
end
