require 'spec_helper'


describe 'simp_options::syslog' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|

      context "on #{os}" do
        let(:facts){ facts }

        context 'default parameters' do
          it { is_expected.to compile.with_all_deps }
        end

        context 'invalid log_servers' do
          let(:params){{ :log_servers => ['1.2.3.4', '2.3.4.500'] }}
          it { is_expected.not_to compile.with_all_deps}
        end

        context 'invalid failover_log_servers' do
          let(:params){{ :failover_log_servers => ['1.2.300.4', '2.3.4.5'] }}
          it { is_expected.not_to compile.with_all_deps}
        end
      end
    end
  end
end
