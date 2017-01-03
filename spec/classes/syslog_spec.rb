require 'spec_helper'

describe 'simp_options' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|

      context "on #{os}" do
        let(:facts){ facts }

        context 'default parameters for simp_options::syslog' do
          let(:hieradata) { 'simp_options'}
          let(:params){{ :syslog => true }}
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('simp_options::syslog').with(
            :log_servers => [],
            :failover_log_servers => []
          ) }
        end

        context 'invalid simp_options::syslog::log_servers' do
          let(:hieradata) { 'simp_options_with_invalid_syslog_log_servers'}
          it { is_expected.not_to compile.with_all_deps}
        end

        context 'invalid simp_options::syslog::failover_log_servers' do
          let(:hieradata) { 'simp_options_with_invalid_syslog_failover_log_servers'}
          it { is_expected.not_to compile.with_all_deps}
        end
      end
    end
  end
end
