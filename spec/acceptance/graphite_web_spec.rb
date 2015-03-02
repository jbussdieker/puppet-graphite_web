require 'spec_helper_acceptance'

describe 'graphite_web class' do
  let(:prefix) { "/opt/graphite" }
  let(:manifest) {
    <<-EOS
    class { 'graphite_web':
    }
    EOS
  }

  describe 'running puppet code' do
    it 'should work with no errors' do
      # Run it twice and test for idempotency
      apply_manifest(manifest, :catch_failures => true)
      expect(apply_manifest(manifest, :catch_changes => true).exit_code).to be_zero
    end
  end
end
