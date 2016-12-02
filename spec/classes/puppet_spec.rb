require 'spec_helper'

describe 'simp_options::puppet' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|

      context "on #{os}" do
        let(:facts){ facts }

        context 'default parameters' do
          let(:params) {{ :server => '1.2.3.4', :ca => '2.3.4.5' }}
          it { is_expected.to compile.with_all_deps }
        end

        context 'invalid server' do
          let(:params) {{ :server => '1000.2.3.4', :ca => '2.3.4.5' }}
          it { is_expected.not_to compile.with_all_deps}
        end

        context 'invalid ca' do
          let(:params) {{ :server => '1.2.3.4', :ca => '2.300.4.5' }}
          it { is_expected.not_to compile.with_all_deps}
        end
      end
    end
  end
end
