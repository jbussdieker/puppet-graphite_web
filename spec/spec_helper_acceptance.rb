require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module
    puppet_module_install(:source => proj_root, :module_name => 'graphite_web')

    hosts.each do |host|
      on host, puppet('module', 'install', 'jbussdieker-whisper'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'jbussdieker-carbon'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-git'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-vcsrepo'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'jfryman-nginx'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'zooz-uwsgi'), { :acceptable_exit_codes => [0,1] }
      apply_manifest(%{
        include git
      })
    end
  end
end
