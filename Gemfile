source 'https://rubygems.org'

group :development, :unit_tests do
  gem 'rspec-puppet'
  gem 'simplecov', :require => false
  gem 'puppetlabs_spec_helper'
end

group :system_tests do
  gem 'beaker', '2.4.1', :require => false
  gem 'beaker-rspec', '5.0.1', :require => false
  gem 'serverspec', :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end
