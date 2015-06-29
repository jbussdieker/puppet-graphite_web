source 'https://rubygems.org'

group :development, :unit_tests do
  gem 'rspec-core', '3.1.7', :require => false
  gem 'simplecov', :require => false
  gem 'puppetlabs_spec_helper', :require => false
  gem 'metadata-json-lint'
end

group :system_tests do
  gem 'beaker-rspec', :require => false
  gem 'serverspec', :require => false
  gem 'beaker-puppet_install_helper', :require => false
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
