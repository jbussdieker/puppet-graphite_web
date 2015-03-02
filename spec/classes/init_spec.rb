require 'spec_helper'

describe 'graphite_web' do
  let(:facts) do
    {
      :operatingsystem => operatingsystem,
      :operatingsystemmajrelease => operatingsystemmajrelease
    }
  end

  context 'Ubuntu' do
    let(:operatingsystem) { 'Ubuntu' }

    context '14.04' do
      let(:operatingsystemmajrelease) { '14.04' }
      it { should have_resource_count(62) }
    end
  end
end
