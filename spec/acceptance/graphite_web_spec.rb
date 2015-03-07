require 'spec_helper_acceptance'

describe 'graphite_web class' do
  let(:prefix) { "/opt/graphite" }
  let(:manifest) {
    <<-EOS
    class { 'whisper::source':
      revision => '0.9.x',
    }
    ->
    class { 'carbon':
      revision => '0.9.x',
      user     => 'www-data',
      caches   => {
        'a' => {
        },
      },
    }
    ->
    file { '/tmp/foo':
      ensure => directory,
      owner  => 'www-data',
      group  => 'www-data',
      mode   => '0755',
    }
    ->
    file { '/tmp/foo/index':
      ensure => file,
      owner  => 'www-data',
      group  => 'www-data',
      mode   => '0644',
    }
    ->
    file { '/tmp/foo/rrd':
      ensure => directory,
      owner  => 'www-data',
      group  => 'www-data',
      mode   => '0755',
    }
    ->
    class { 'graphite_web':
      revision   => '0.9.x',
      index_file => '/tmp/foo/index',
      rrd_dir    => '/tmp/foo/rrd',
      dbfile     => '/tmp/foo/graphite.db',
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

  describe 'graphite' do
    it 'should be hosting on port 8080' do
      shell("/usr/bin/curl localhost:8080", {:acceptable_exit_codes => 0}) do |r|
        expect(r.stdout).to match("Graphite Browser")
      end
    end

    it 'should be able to render json' do
      shell("curl localhost:8080/render?format=json", {:acceptable_exit_codes => 0}) do |r|
        expect(r.stdout).to eq("[]")
      end
    end

    it 'should be able to render png' do
      shell("curl localhost:8080/render?format=png", {:acceptable_exit_codes => 0}) do |r|
        expect(r.stdout).to match("PNG")
      end
    end

    it 'should be able to render metrics' do
      shell("curl \"localhost:8080/render?target=carbon.*.*.*\"", {:acceptable_exit_codes => 0}) do |r|
        expect(r.stdout).to match("PNG")
      end
    end
  end
end
