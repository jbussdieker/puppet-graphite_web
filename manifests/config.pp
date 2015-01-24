class graphite::config(
  $prefix = $graphite::params::prefix
) inherits graphite::params {

  file { "${prefix}/webapp/graphite/local_settings.py":
    ensure  => present,
    content => template('graphite/local_settings.py.erb'),
  }

}
