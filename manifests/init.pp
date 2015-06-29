# == Class: graphite_web
#
class graphite_web(
  $prefix = '/opt/graphite',
  $source = 'https://github.com/graphite-project/graphite-web.git',
  $source_path = '/usr/local/src/graphite-web',
  $revision = '0.9.x',
  $data_dirs = undef,
  $cluster_servers = undef,
  $carbonlink_hosts = undef,
  $whisper_dir = undef,
  $time_zone = undef,
  $dbfile = '/opt/graphite/storage/graphite.db',
  $index_file = undef,
  $rrd_dir = undef,
  $user = 'www-data',
) {

  if defined(Class['graphite_web::vhost']) {
    $notify_resource = Class['graphite_web::vhost']
  } else {
    $notify_resource = undef
  }

  package { 'python-cairo': }
->
  package { 'python-django': }
->
  package { 'python-django-tagging': }
->
  package { 'python-tz': }
->
  vcsrepo { $source_path:
    ensure   => present,
    revision => $revision,
    source   => $source,
    provider => git,
    notify   => Exec['install_graphite_web'],
  }

  exec { 'install_graphite_web':
    cwd         => $source_path,
    command     => "/usr/bin/python setup.py install --prefix ${prefix}",
    refreshonly => true,
    require     => Vcsrepo[$source_path],
  }

  file { "${prefix}/conf/graphite.wsgi":
    ensure  => present,
    source  => "${prefix}/conf/graphite.wsgi.example",
    require => Exec['install_graphite_web'],
  }

  file { [
      "${prefix}/storage",
      "${prefix}/storage/log/webapp",
    ]:
    ensure  => directory,
    owner   => $user,
    group   => $user,
    mode    => '0755',
    notify  => $notify_resource,
    require => Exec['install_graphite_web'],
  }

  file { "${prefix}/webapp/graphite/local_settings.py":
    ensure  => present,
    content => template('graphite_web/local_settings.py.erb'),
    notify  => $notify_resource,
    require => Exec['install_graphite_web'],
  }

  exec { 'create_database':
    command     => '/usr/bin/django-admin syncdb --settings=graphite.settings --noinput',
    environment => "PYTHONPATH=${prefix}/webapp",
    creates     => $dbfile,
    require     => File["${prefix}/webapp/graphite/local_settings.py"],
  }

  file { $dbfile:
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0644',
    require => Exec['create_database'],
  }

}
