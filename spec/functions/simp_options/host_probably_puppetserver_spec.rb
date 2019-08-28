require 'spec_helper'

describe 'simp_options::host_probably_puppetserver' do
  context 'on a server without a puppetserver installed' do
    before(:each) do
      subject.func.expects(:found_puppetserver_apps?).returns false
    end

    it { is_expected.to run.and_return(false) }
  end

  context 'on a server with a puppetserver installed' do
    before(:each) do
      subject.func.expects(:found_puppetserver_apps?).returns true
    end

    it { is_expected.to run.and_return(true) }
  end
end
