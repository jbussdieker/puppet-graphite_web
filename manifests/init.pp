class graphite_web(
  $prefix = '/opt/graphite',
  $source = 'https://github.com/graphite-project/graphite-web.git',
  $source_path = '/usr/local/src/graphite-web',
  $revision = 'master',
) {

  include nginx
  include uwsgi

  package { 'python-cairo': }
  package { 'python-django': }
  package { 'python-django-tagging': }

  vcsrepo { $source_path:
    ensure   => present,
    revision => $revision,
    source   => $source,
    provider => git,
  }

  exec { 'install_graphite_web':
    cwd     => $source_path,
    command => "/usr/bin/python setup.py install --prefix ${prefix}",
    creates => "${prefix}/webapp",
    require => Vcsrepo[$source_path],
  }

  exec { 'create_database':
    command => "/usr/bin/python ${prefix}/webapp/graphite/manage.py syncdb --noinput",
    creates => "${prefix}/storage/graphite.db",
    require => Exec['install_graphite_web'],
  }

  file { "${prefix}/conf/graphite.wsgi":
    ensure  => present,
    source  => "${prefix}/conf/graphite.wsgi.example",
    require => Exec['install_graphite_web'],
    notify  => Class['uswgi'],
  }

  uwsgi::manage_app { 'graphite':
    ensure => 'present',
    uid    => 'www-data',
    gid    => 'www-data',
    config => {
      'socket' => ':8081',
      'processes' => 4,
      'wsgi-file' => '/opt/graphite/conf/graphite.wsgi',
      'plugins' => 'python',
    },
    notify  => Class['uswgi'],
  }

  nginx::resource::vhost { 'graphite':
    listen_port         => '8080',
    location_custom_cfg => {
      'uwsgi_pass' => '127.0.0.1:8081',
      'include'    => 'uwsgi_params',
    },
  }

  file { [
    "${prefix}/storage/graphite.db",
    "${prefix}/storage/log/webapp",
  ]:
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => 0755,
    require => [
      Exec['install_graphite_web'],
      Exec['create_database'],
    ],
    notify  => Class['uswgi'],
  }

  file { "${prefix}/webapp/graphite/local_settings.py":
    ensure  => present,
    content => template('graphite_web/local_settings.py.erb'),
    notify  => Class['uswgi'],
  }

}
