class graphite::config(
  $prefix = $graphite::params::prefix
) inherits graphite::params {

  file { "${prefix}/webapp/graphite/local_settings.py":
    ensure  => present,
    content => template('graphite/local_settings.py.erb'),
  }

#  file { "${prefix}/conf/graphite.wsgi":
#    ensure  => present,
#    source  => "${prefix}/conf/graphite.wsgi.example",
#    #content => template('graphite/graphite.wsgi.erb'),
#    notify  => Class['uwsgi'],
#  }

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
