class graphite::config(
  $prefix = $graphite::params::prefix
) inherits graphite::params {

  file { "${prefix}/webapp/graphite/local_settings.py":
    ensure  => present,
    content => template('graphite/local_settings.py.erb'),
  }

#  file { [
#    "${prefix}/storage",
#    "${prefix}/storage/whisper",
#    "${prefix}/storage/log",
#    "${prefix}/storage/log/webapp"
#  ]:
#    ensure => directory,
#    owner  => 'www-data',
#    group  => 'www-data',
#    mode   => 0755,
#  }

}
