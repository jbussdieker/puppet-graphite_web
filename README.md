# Graphite Web

[![Puppet Forge](http://img.shields.io/puppetforge/v/jbussdieker/graphite_web.svg)](https://forge.puppetlabs.com/jbussdieker/graphite_web)
[![Build Status](https://travis-ci.org/jbussdieker/puppet-graphite_web.svg?branch=master)](https://travis-ci.org/jbussdieker/puppet-graphite_web)

## Usage

To install Graphite with the default parameters

```puppet
class { 'graphite_web': }
```

Installing a specific version

```puppet
class { 'graphite_web':
  revision => '0.9.11',
}
```

Installing and configuring using Hiera

```yaml
classes:
 - graphite_web
graphite_web::revision: 0.9.11
```

## Testing

    bundle exec rake beaker_nodes

    # Use the list the previous command prints to pick a value for BEAKER_set

    # When starting testing set provision=yes
    bundle exec rake beaker BEAKER_destroy=no BEAKER_set=ubuntu-server-1404-x64 BEAKER_provision=yes
    # Make changes/corrections
    ...
    # Run again without provisioning (quicker but not a thorough test)
    bundle exec rake beaker BEAKER_destroy=no BEAKER_set=ubuntu-server-1404-x64 BEAKER_provision=no
