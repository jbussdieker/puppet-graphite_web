require 'spec_helper'

describe 'graphite_web::vhost' do
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
      it { should have_resource_count(12) }
    end
  end
end
