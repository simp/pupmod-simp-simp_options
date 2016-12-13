require 'spec_helper'

describe 'simp_options' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|

      context "on #{os}" do
        let(:facts){ facts }

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
