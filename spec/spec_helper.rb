require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'

at_exit { RSpec::Puppet::Coverage.report! }

RSpec.configure do |c|
  c.default_facts = {
    :kernel          => 'Linux',
    :concat_basedir  => '/var/lib/puppet/concat',
  }
end
