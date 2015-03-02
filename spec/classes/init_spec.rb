require 'spec_helper'

describe 'graphite_web' do
  it { should have_resource_count(7) }
end
